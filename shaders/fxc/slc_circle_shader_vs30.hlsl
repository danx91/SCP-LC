/*
Copyright 2026 danx91

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

float4x4 cModelViewProj     : register(c4);
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

struct VS_INPUT
{
    float4 pos              : POSITION;
    float2 uv               : TEXCOORD0;
    float4 color            : COLOR0;
};

struct VS_OUTPUT
{
    float4 pos              : POSITION;
    float2 uv               : TEXCOORD0;
    float4 color            : TEXCOORD1;
    float3 outline_color    : TEXCOORD2;
};

inline float3 sRGBToLinear(float3 srgb)
{
    return pow(max(srgb, 0.0), 2.2);
}

VS_OUTPUT main( const VS_INPUT v )
{
    VS_OUTPUT o = ( VS_OUTPUT )0;

    o.pos       = mul( float4( v.pos.xyz, 1.0f ), cModelViewProj );
    o.uv        = v.uv;
    o.color     = v.color;

    o.color.rgb     = sRGBToLinear(o.color.rgb);
    o.outline_color = sRGBToLinear(OUTLINE_COLOR);

    return o;
}