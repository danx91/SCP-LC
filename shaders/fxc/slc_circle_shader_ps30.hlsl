/*
Copyright 2026 danx91

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

/*
    This is a shader that is capable of drawing circles, pies, rings and arcs with optional soft caps to use in screenspace_general.
    Calling from Lua:

    function DrawCircle(
        x, y, size,
        radius, inner_radius, cap_radius,
        outline, rotation, fill,
        outline_color_r, outline_color_g, outline_color_b,
        texture
    )
        local angle = fill * pi

        local mid_r = ( radius + inner_radius ) * 0.5

        local h = ( radius - inner_radius ) * 0.5
        local maxcap = angle * mid_r

        if cap_radius > maxcap then cap_radius = maxcap end
        if cap_radius > h then cap_radius = h end

        local ratio = cap_radius / mid_r
        if ratio > 1 then ratio = 1 end

        local cap_angle = math.asin( ratio );

        local corrected_angle = angle - cap_angle * ( 1 - fill )
        if corrected_angle < 0 then corrected_angle = 0 end

        local rotation_rad = math.rad( rotation ) - pi - corrected_angle - cap_angle

        local r_eff = radius - cap_radius
        local i_eff = inner_radius + cap_radius
        local h_eff = (r_eff - i_eff) * 0.5

        SHADER_MATRIX:SetUnpacked(
            radius, 		cap_radius,	math.sin( rotation_rad ),		outline_color_r / 255,
            inner_radius, 	r_eff,		math.cos( rotation_rad ),		outline_color_g / 255,
            outline, 		i_eff,		math.sin( corrected_angle ), 	outline_color_b / 255,
            angle,			h_eff,		math.cos( corrected_angle ),	texture and 1 or 0
        )

        SHADER_MATERIAL:SetMatrix( "$viewprojmat", SHADER_MATRIX )

        surface.SetMaterial( SHADER_MATERIAL )
        surface.DrawTexturedRectUV( x, y, size, size, -0.015625, -0.015625, 1.015625, 1.015625 )
    end
*/

struct PS_INPUT
{
    float4 pos              : POSITION;
    float2 uv               : TEXCOORD0;
    float4 color            : TEXCOORD1;
};

sampler BaseTexture         : register( s0 );

const float4x4 cViewProj    : register(c11);

#define RADIUS              cViewProj[0].x
#define INNER_RADIUS        cViewProj[0].y
#define OUTLINE             cViewProj[0].z
#define ANGLE               cViewProj[0].w

#define CAP_RADIUS          cViewProj[1].x
#define R_EFF               cViewProj[1].y
#define I_EFF               cViewProj[1].z
#define H_EFF               cViewProj[1].w

#define SIN_ROT             cViewProj[2].x
#define COS_ROT             cViewProj[2].y
#define SIN_ANG             cViewProj[2].z
#define COS_ANG             cViewProj[2].w

#define OUTLINE_COLOR       cViewProj[3].xyz
#define USE_TEXTURE         cViewProj[3].w

// Constants
#define PI                  3.14159265
#define TWO_PI              6.28318530

// Proudly stolen from https://github.com/Srlion/RNDX/blob/master/src/common_rounded.hlsl
// and then optimized a bit :)
// Original comment: Thanks to https://bohdon.com/docs/smooth-sdf-shape-edges/ awesome article
float uv_filter_width_bias(float dist, float2 uv)
{
    float2 dpos = fwidth(uv);
    float fw    = max(dpos.x, dpos.y);

    // Optimized math: 1.0 - (dist + 0.5*fw)/fw  =>  0.5 - dist/fw
    return saturate(0.5 - dist / fw);
}

float blended_AA(float dist, float2 uv)
{
    float linear_cov = uv_filter_width_bias(dist, uv);
    float smooth_cov = smoothstep(1.0, 0.0, dist + 1.0);

    return lerp(linear_cov, smooth_cov, 0.06);
}

// Based on https://iquilezles.org/articles/distfunctions2d/
float sdAnnularPie(float2 p, float2 c)
{
    p.x = abs(p.x);

    float l = abs(length(p) - (I_EFF + H_EFF)) - H_EFF;
    float m = length(p - c * clamp(dot(p, c), I_EFF, R_EFF));

    return max(l, m * sign(c.y * p.x - c.x * p.y)) - CAP_RADIUS;
}

float4 main(PS_INPUT i) : COLOR
{
    [branch] if (ANGLE <= 1e-4) return float4(0.0, 0.0, 0.0, 0.0);

    float2 p = (i.uv - 0.5) * (RADIUS * 2.0);
    p = float2(p.x * COS_ROT - p.y * SIN_ROT, p.x * SIN_ROT + p.y * COS_ROT);

    float d;

    [branch] if (ANGLE >= PI - 1e-3) 
    {
        float len   = length(p);
        float dPie  = len - RADIUS;

        float dRing = max(len - RADIUS, INNER_RADIUS - len);
        
        d = (INNER_RADIUS <= 1e-3) ? dPie : dRing;
    }
    else
    {
        float2 c = float2(SIN_ANG, COS_ANG);
        d = sdAnnularPie(p, c);
    }

    float outerAlpha    = blended_AA(d, p);
    float outlineBlend  = blended_AA(d + OUTLINE, p);
    float fillWeight    = saturate(outlineBlend / max(outerAlpha, 0.0001));

    float4 finalColor   = USE_TEXTURE == 1 ? tex2D(BaseTexture, i.uv) * i.color : i.color;
    finalColor.rgb      = lerp(OUTLINE_COLOR.rgb, finalColor.rgb, fillWeight);
    finalColor.a       *= outerAlpha;

    return finalColor;
}