SWEP.Base 						= "item_slc_base"
SWEP.Language 					= "FLASHLIGHT"

SWEP.ViewModel					= "models/slc/flashlight/c_flashlight.mdl"
SWEP.WorldModel					= "models/slc/flashlight/w_flashlight.mdl"
SWEP.UseHands					= true

SWEP.HoldType 					= "pistol"

SWEP.Toggleable 				= true
SWEP.HasBattery 				= true
SWEP.BatteryUsage 				= 3

SWEP.WorldModelPositionOffset 	= Vector( 4, -2, -1 )
SWEP.WorldModelAngleOffset 		= Angle( 0, 0, 0 )

SWEP.ViewModelPositionOffset 	= Vector( 10, 6, -5 )
SWEP.ViewModelAngleOffset 		= Angle( 0, 0, 0 )

SWEP.BoneAttachment 			= "ValveBiped.Bip01_R_Hand"

SWEP.DrawCrosshair 				= false

if CLIENT then
	SWEP.WepSelectIcon = Material( "slc/items/flashlight.png" )
	SWEP.SelectColor = Color( 255, 210, 0, 255 )
end

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )

	self:NetworkVar( "Entity", "Light" )
end

function SWEP:Initialize()
	self:CallBaseClass( "Initialize" )

	if CLIENT then
		self.PixelVis = util.GetPixelVisibleHandle()
	end
end

function SWEP:OnRemove()
	if CLIENT then return end

	local light = self:GetLight()
	if IsValid( light ) then
		light:Remove()
	end
end

function SWEP:OnDrop()
	self:SetEnabled( false )

	if CLIENT then return end

	local light = self:GetLight()
	if IsValid( light ) then
		light:Remove()
	end
end

function SWEP:Deploy()
	self:CallBaseClass( "Deploy" )

	if SERVER then
		local light = self:GetLight()
		if !IsValid( light ) then
			self:CreateLight()
		end
	end

	return true
end

function SWEP:Holster()
	self:SetEnabled( false )

	if SERVER then
		local light = self:GetLight()
		if IsValid( light ) then
			light:Fire( "TurnOff" )
		end
	end

	return true
end

function SWEP:BatteryDepleted()
	if SERVER then
		local light = self:GetLight()
		if IsValid( light ) then
			light:Fire( "TurnOff" )
		end
	end
end

SWEP.BatteryFlicker = 0
function SWEP:Think()
	self:BatteryTick()

	if CLIENT or !self:GetEnabled() then return end

	local owner = self:GetOwner()
	if !IsValid( owner ) then return end

	local light = self:GetLight()
	if !IsValid( light ) then return end

	local aim = owner:GetAimVector()
	light:SetPos( owner:GetShootPos() + aim * 25 )
	light:SetAngles( aim:Angle() )
	
	local bat = self:GetBattery()
	if self.BatteryFlicker != bat then
		self.BatteryFlicker = bat
		self:UpdateLightStyle()
	end
end

local toggle_speed = 2
function SWEP:PrimaryAttack()
	if self:GetBattery() <= 0 or !IsFirstTimePredicted() then return end

	local vm = self:GetOwner():GetViewModel()
	local seq, dur = vm:LookupSequence( "toggle" )

	vm:SendViewModelMatchingSequence( seq )
	vm:SetPlaybackRate( toggle_speed )

	self:SetNextPrimaryFire( CurTime() + dur / toggle_speed )

	local enabled = !self:GetEnabled()
	self:SetEnabled( enabled )
	self:EmitSound( enabled and "Player.FlashlightOn" or "Player.FlashlightOff" )

	if CLIENT then return end

	local light = self:GetLight()
	if !IsValid( light ) then return end

	light:Fire( enabled and "TurnOn" or "TurnOff" )
	self:UpdateLightStyle()
end

function SWEP:CreateLight()
	local old = self:GetLight()
	if IsValid( old ) then
		old:Remove()
	end

	local light = ents.Create( "env_projectedtexture" )
	if IsValid( light ) then
		light:SetKeyValue( "nearz", 4 )
		light:SetKeyValue( "farz", 800 )
		light:SetKeyValue( "lightfov", 60 )
		light:SetKeyValue( "lightcolor", "255 255 255" )
		light:SetKeyValue( "enableshadows", 1 )
		light:SetKeyValue( "lightworld", 1 )

		light:Fire( "AlwaysUpdateOn" )
		light:Fire( "SpotlightTexture", "effects/flashlight001" )
		self:SetLight( light )
	end
end

function SWEP:UpdateLightStyle()
	local light = self:GetLight()
	if !IsValid( light ) then return end

	local bat = self:GetBattery()
	local style = 0//"m"

	/*if bat <= 1 then
		//style = "llelblkclekkelebeeflellfe"
	else*/if bat <= 3 then
		//style = "mmnjkmkmmkkjmkmmnjnkmmj"
		style = 10
	elseif bat <= 6 then
		//style = "mmnkmnmmkmmnknmmnnonmmn"
		style = 6
	elseif bat <= 12 then
		//style = "mmlmmnmmnmmlnmmmmnlmmln"
		style = 1
	end

	if light.Style != style then
		light.Style = style
		//light:Fire( "SetPattern", style )
		light:Fire( "SetLightStyle", style )
		//print( "set style", self:GetOwner(), light, style )
	end
end

local light_sprite = Material( "sprites/slc_light_sprite" )
local light_beam = Material( "sprites/slc_light_beam" )

local light_trace = {}
light_trace.output = light_trace
light_trace.mins = Vector( -8, -8, -3 )
light_trace.maxs = Vector( 8, 8, 3 )

function SWEP:CalcViewModelView( vm, old_pos, old_ang, pos, ang )
	/*local id = vm:LookupAttachment( "light" )
	if id <= 0 then return end

	local owner = self:GetOwner()
	local start = owner:EyePos()

	light_trace.start = start
	light_trace.endpos = start + owner:EyeAngles():Forward() * 50
	light_trace.mask = MASK_SOLID
	light_trace.filter = owner

	util.TraceHull( light_trace )

	if light_trace.Hit then
		local frac = 1 - light_trace.Fraction * 1.2

		if frac < 0 then
			frac = 0
		end

		return pos - ang:Forward() * frac * 30, ang
	end*/
end

function SWEP:PreDrawViewModel( vm, wep, ply )
	if !self:GetEnabled() then return end

	local light = self:GetLight()
	if !IsValid( light ) then return end

	local id = vm:LookupAttachment( "light" )
	if id > 0 then
		local att = vm:GetAttachment( id )
		light:SetRenderOrigin( att.Pos )
		light:SetRenderAngles( att.Ang )
	else
		light:SetRenderOrigin( vm:GetPos() )
		light:SetRenderAngles( vm:GetAngles() )
	end
end

local spriterenderer = {}
local beamrenderer = {}

function SWEP:DrawWorldModel()
	self:DrawModel()

	if !self:GetEnabled() then return end
	
	local owner = self:GetOwner()
	if !IsValid( owner ) then return end

	local id = self:LookupAttachment( "light" )
	if id <= 0 then return end

	local att = self:GetAttachment( id )

	local forward = att.Ang:Forward()
	local pos = att.Pos

	self:GetLight():SetRenderAngles( att.Ang )

	light_trace.start = pos
	light_trace.endpos = pos + forward * 500
	light_trace.mask = MASK_BLOCKLOS_AND_NPCS
	light_trace.filter = { self, owner }

	util.TraceLine( light_trace )

	if light_trace.StartSolid or light_trace.HitPos:DistToSqr( pos ) < 100 then return end
	
	local dot = ( LocalPlayer():EyePos() - pos ):GetNormalized():Dot( forward )
	
	local beamalpha = 1
	if dot > 0.4 then
		beamalpha = math.Clamp( ( 0.8 - dot ) / 0.4, 0, 1 )
	end
	
	if beamalpha > 0 then
		beamrenderer[#beamrenderer + 1] = { pos, light_trace.HitPos, beamalpha }
	end

	if dot < 0 then return end

	local vis = util.PixelVisible( pos, 3, self.PixelVis )
	local alpha = math.Clamp( 255 * vis * ( dot - 0.4 ) / 0.6, 0, 255 )
	local size = math.Clamp( 128 * vis * ( dot - 0.6 ) / 0.4, 32, 128 )

	spriterenderer[#spriterenderer + 1] = { pos, size, alpha }
end

hook.Add( "PostDrawOpaqueRenderables", "FlashLightSprite", function()
	render.SetMaterial( light_sprite )

	for k, v in pairs( spriterenderer ) do
		render.DrawSprite( v[1], v[2], v[2], Color( 255, 255, 255, v[3] ) )
	end

	render.SetMaterial( light_beam )

	for k, v in pairs( beamrenderer ) do
		render.StartBeam( 2 )
			render.AddBeam( v[1], 30, 0, Color( 255, 255, 255, 5 * v[3] ) )
			render.AddBeam( v[2], 30, 0.97, Color( 255, 255, 255, 15 * v[3] ) )
		render.EndBeam()
	end

	beamrenderer = {}
	spriterenderer = {}
end )