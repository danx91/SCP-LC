AddCSLuaFile()

ENT.Base = "slc_display_base"
ENT.Model = "models/props/alski/warhead2_screen.mdl"

//ENT.FirstCard = false
//ENT.SecondCard = false

local CARD_POS = {
	{ pos = Vector( -1, 3.3, 18.8 ), ang = Angle( 0, 90, 0 ) },
	{ pos = Vector( -1, 3.3, 8.9 ), ang = Angle( 0, 90, 0 ) },
}

local STATE_IDLE = 0
local STATE_READY = 1
local STATE_NOREMOTE = 2
local STATE_COUNTDOWN = 3
local STATE_NONE = 4

function ENT:SetupDataTables()
	self:AddNetworkVar( "State", "Int" )
	self:AddNetworkVar( "Time", "Float" )
end

function ENT:Think()
	if SERVER then
		local ct = CurTime()
		local state = self:GetState()

		if state == STATE_NOREMOTE and self.NUse <= ct then
			self:SetState( STATE_READY )
		end
	end
end

function ENT:AccessOverride( ply, data )
	--if self:GetState() == STATE_IDLE then
	if !self.Usable then
		if !self.FirstCard and ply:HasWeapon( "item_slc_alpha_card1" ) then
			self.FirstCard = true
			ply:StripWeapon( "item_slc_alpha_card1" )
			self:SpawnCard( 1 )

			if self.SecondCard then
				self:SetState( STATE_READY )
				self.Usable = true
			end

			return false, "alpha_card"
		elseif !self.SecondCard and ply:HasWeapon( "item_slc_alpha_card2" ) then
			self.SecondCard = true
			ply:StripWeapon( "item_slc_alpha_card2" )
			self:SpawnCard( 2 )

			if self.FirstCard then
				self:SetState( STATE_READY )
				self.Usable = true
			end

			return false, "alpha_card"
		end
	end

	if !self.Usable or self.NUse > CurTime() then
		return false, ""
	end
end

function ENT:OnUse( ply )
	if ALPHA_REMOTE_CHECK() then
		if ALPHAWarhead( ply ) then
			self:SetState( STATE_COUNTDOWN )
			self:SetTime( CurTime() + CVAR.alpha_time:GetInt() + 3 )
			self.Usable = false
		end
	else
		self:SetState( STATE_NOREMOTE )
		self.NUse = CurTime() + 3
	end
end

function ENT:SpawnCard( id )
	local card = ents.Create( "slc_linear_motion_base" )
	if IsValid( card ) then
		card.Model = "models/slc/nuclear_card.mdl"
		card:SetModelScale( 0.5 )
		card:SetPos( self:LocalToWorld( CARD_POS[id].pos + Vector( 4, 0, 0 ) ) )
		card:SetAngles( self:LocalToWorldAngles( CARD_POS[id].ang ) )
		card:Spawn()

		card:AddPoint{
			pos = self:LocalToWorld( CARD_POS[id].pos ),
			time = 1
		}
		card:StartMovement()
	end
end

if CLIENT then
	local tc = Color( 175, 175, 175, 255 )

	function ENT:RenderScreen( width, height )
		local state = self:GetState()
		if state == STATE_NONE then return end

		local text
		if state == STATE_IDLE then
			text = LANG.MISC.alpha_warhead.idle
		elseif state == STATE_READY then
			text = LANG.MISC.alpha_warhead.ready
		elseif state == STATE_NOREMOTE then
			text = LANG.MISC.alpha_warhead.no_remote
		elseif state == STATE_COUNTDOWN then
			local time = self:GetTime() - CurTime()
			if time < 0 then
				time = 0
			end

			text = string.format( LANG.MISC.alpha_warhead.active, time )
		end

		if text then
			draw.MultilineText( width / 2, height * 0.09, text, "SCPAlphaDisplay", tc, width, 10, 5, TEXT_ALIGN_CENTER )
		end
	end

	hook.Add( "RebuildFonts", "SLCAlphaFont", function()
		surface.CreateFont( "SCPAlphaDisplay", {
			font = "Impacted",
			size = 52,
			antialias = true,
			weight = 500,
			extended = true
		} )
	end )
end