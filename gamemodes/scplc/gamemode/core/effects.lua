--[[-------------------------------------------------------------------------
These are graphical effects! For player status effects look at '../modules/sh_effects.lua'
---------------------------------------------------------------------------]]
local function beam_noise( noise, scale, divs, offset )
	divs = divs or #noise - 1
	if divs < 2 then return end

	offset = offset or 0

	local div = math.ceil( divs / 2 )
	noise[div + 1 + offset] = ( noise[1 + offset] + noise[divs + 1 + offset] ) * 0.5 + scale * ( math.random() * 2 - 1 )

	if div <= 1 then return end

	beam_noise( noise, scale * 0.5, div, div + offset )
	beam_noise( noise, scale * 0.5, div, offset )
end

--[[-------------------------------------------------------------------------
data = {
	vec_start = Vector,
	ent_start = Entity,
	attachment_start = number,

	vec_end = Vector,
	ent_end = Entity,
	attachment_end = number,

	material = IMaterial,
	color = Color,
	segments = number,

	speed = number,
	amplitude = number,
	width = number,
	width_end = number,
	life = number,
	fade = number,
	divs = number,
}
---------------------------------------------------------------------------]]
BEAM_USE_ENTITY = bit.lshift( 1, 0 )
BEAM_FADE_IN = bit.lshift( 1, 1 )
BEAM_FADE_OUT = bit.lshift( 1, 2 )

local beams = {}

function GenericBeam( data )
	if !data.material then return end

	local ct = CurTime()

	local beam = table.Copy( data )

	beam.flags = data.flags or 0
	beam.die = ct + data.life
	beam.freq = ct * data.speed

	if IsValid( data.ent_start ) or IsValid( data.ent_end ) then
		beam.flags = bit.bor( beam.flags, BEAM_USE_ENTITY )
	else
		local delta = beam.vec_end - beam.vec_start
		beam.delta = delta

		if data.segments then
			beam.segments = data.segments
		elseif beam.amplitude >= 0.5 then
			beam.segments = delta:Length() * 0.25 + 3
		else
			beam.segments = delta:Length() * 0.075 + 3
		end
	end

	beam.noise = PopulateTable( data.divs + 1, 0 )

	UpdateBeam( beam, 0 )

	table.insert( beams, beam )
	return beam
end

function UpdateBeam( beam, dt )
	if bit.band( beam.flags, BEAM_USE_ENTITY ) != 0 then
		if IsValid( beam.ent_start ) then
			beam.vec_start = beam.ent_start:GetAttachment( beam.attachment_start ).Pos
		end

		if IsValid( beam.ent_end ) then
			beam.vec_end = beam.ent_start:GetAttachment( beam.attachment_end ).Pos
		end

		local delta = beam.vec_end - beam.vec_start
		beam.delta = delta

		if beam.amplitude >= 0.5 then
			beam.segments = delta:Length() * 0.25 + 3
		else
			beam.segments = delta:Length() * 0.075 + 3
		end
	end

	beam.freq = beam.freq + dt * ( math.random() + 1 )

	beam_noise( beam.noise, 1 )

	local t = beam.freq + ( beam.die - CurTime() )
	if t != 0 then
		beam.t = beam.freq / t
	else
		beam.t = 1
	end

	if beam.fade == 0 then
		beam.fade = beam.delta:Length()
	end
end

local tmp_color = Color( 0, 0, 0 )
function RenderBeam( beam )
	if beam.fade < 0 or beam.segments < 2 or beam.delta:LengthSqr() < 0.01 then return end

	if bit.band( beam.flags, BEAM_FADE_IN ) != 0 then
		tmp_color.r = beam.color.r * beam.t
		tmp_color.g = beam.color.g * beam.t
		tmp_color.b = beam.color.b * beam.t
	elseif bit.band( beam.flags, BEAM_FADE_OUT ) != 0 then
		tmp_color.r = beam.color.r * ( 1 - beam.t )
		tmp_color.g = beam.color.g * ( 1 - beam.t )
		tmp_color.b = beam.color.b * ( 1 - beam.t )
	else
		tmp_color.r = beam.color.r
		tmp_color.g = beam.color.g
		tmp_color.b = beam.color.b
	end

	render.SetMaterial( beam.material )

	local segments = beam.segments
	local delta_l = beam.delta:Length()
	local length = delta_l
	local max_width = beam.width

	if beam.width_end > max_width then
		max_width = beam.width_end
	end

	local div = 1 / ( segments - 1 )

	if length * div < max_width * 1.414 then
		segments = math.floor( length / ( max_width * 1.414 ) ) + 1

		if segments < 2 then
			segments = 2
		end
	end

	local noise_div = #beam.noise - 1
	if segments > noise_div then
		segments = noise_div
	end

	div = 1 / ( segments - 1 )
	length = length * 0.01

	local v_step = length * div
	local v_last = math.fmod( beam.freq * beam.speed, 1 )
	local scale = beam.amplitude * length

	local noise_step = math.floor( ( noise_div - 1 ) * div * 65536 )
	local noise_index = 0

	//local fade_fraction = math.Clamp( beam.fade / delta_l, 1e-6, 1 )
	//local brightness = 1

	local perp = beam.delta:GetNormalized()
	perp = perp:Cross( EyeAngles():Forward() )
	perp:Normalize()

	render.StartBeam( segments )

	for i = 1, segments do
		local fraction = ( i - 1 ) * div

		//TODO: SHADE_IN, SHADE_OUT

		local pos = beam.vec_start + beam.delta * fraction

		if scale != 0 then
			local ni = bit.rshift( noise_index, 16 ) + 1
			factor = beam.noise[ni] * scale
			pos:Add( perp * factor )
		end

		local width
		if beam.width == beam.width_end then
			width = beam.width * 2
		else
			width = ( beam.width + ( beam.width_end - beam.width ) * fraction ) * 2
		end

		render.AddBeam( pos, width, v_last, tmp_color )

		v_last = v_last + v_step
		noise_index = noise_index + noise_step
	end

	render.EndBeam()
end

hook.Add( "PreDrawEffects", "SLCBeams", function()
	local len = #beams
	if len <= 0 then return end

	render.OverrideBlend( true, BLEND_SRC_COLOR, BLEND_ONE, BLENDFUNC_ADD, BLEND_SRC_ALPHA, BLEND_ONE_MINUS_SRC_ALPHA, BLENDFUNC_ADD )
	render.OverrideDepthEnable( true, false )

	local ct = CurTime()

	for i = len, 1, -1 do
		local v = beams[i]

		if v.die < ct then
			table.remove( beams, i )
			continue
		end

		UpdateBeam( v, FrameTime() )
		RenderBeam( v )
	end

	render.OverrideBlend( false )
	render.OverrideDepthEnable( false )
end )

function TeslaBeam( data )

end