AddCSLuaFile()

ENT.Base = "slc_display_base"
ENT.Model = "models/props/alski/warhead_screen.mdl"

local STATE_IDLE = 0
local STATE_ACTIVE = 1
local STATE_COOLDOWN = 2

function ENT:SetupDataTables()
	self:AddNetworkVar( "State", "Int" )
	self:AddNetworkVar( "Time", "Float" )
end

function ENT:Initialize()
	self:CallBaseClass( "Initialize" )

	if SERVER then
		self:SetState( STATE_COOLDOWN )
		self:SetTime( CurTime() + CVAR.slc_intercom_cooldown:GetInt() )
	end
end

function ENT:Think()
	if SERVER then
		local state = self:GetState()
		if state == STATE_IDLE then return end
		
		local ct = CurTime()
		local time = self:GetTime()

		if time >= ct then
			local ply = self.ActivePlayer
			if state == STATE_ACTIVE and ( !IsValid( ply ) or !ply:Alive() or ply:GetPos():DistToSqr( self:GetPos() ) > 10000 ) then
				self:StopTransmit()
			end

			return
		end

		if state == STATE_COOLDOWN then
			self:SetState( STATE_IDLE )
			self:SetTime( 0 )
			self.NUse = ct + 1
		elseif state == STATE_ACTIVE then
			self:StopTransmit()
		end
	end
end

function ENT:AccessOverride( ply, data )
	if !self.Usable or self.NUse > CurTime() or self:GetState() != STATE_IDLE or ply:GetPos():DistToSqr( self:GetPos() ) > 10000 or IsPAActive() then
		return false, ""
	end
end

function ENT:OnUse( ply )
	self:SetState( STATE_ACTIVE )
	self:SetTime( CurTime() + CVAR.slc_intercom_duration:GetInt() )
	self.ActivePlayer = ply

	TransmitSound( "scp_lc/misc/v_start.ogg", true, 1 )
	PausePA()
end

function ENT:StopTransmit()
	self.ActivePlayer = nil
	self:SetState( STATE_COOLDOWN )
	self:SetTime( CurTime() + CVAR.slc_intercom_cooldown:GetInt() )
	
	TransmitSound( "scp_lc/misc/v_end.ogg", true, 1 )
	UnPausePA()
end

hook.Add( "PlayerSpeakOverride", "SLCIntercom", function( talker )
	if !IsValid( INTERCOM_SCREEN ) or !IsValid( INTERCOM_SCREEN.ActivePlayer ) then return end
	if talker == INTERCOM_SCREEN.ActivePlayer then
		return true
	end
end )

if CLIENT then
	local tc = Color( 175, 175, 175, 255 )

	function ENT:RenderScreen( width, height )
		local state = self:GetState()
		local time = self:GetTime() - CurTime()

		if time < 0 then
			time = 0
		end

		local text = LANG.MISC.intercom.name.."\n"
		if state == STATE_IDLE then
			text = text..LANG.MISC.intercom.idle
		elseif state == STATE_ACTIVE then
			text = text..string.format( LANG.MISC.intercom.active, math.ceil( time ) )
		elseif state == STATE_COOLDOWN then
			text = text..string.format( LANG.MISC.intercom.cooldown, math.ceil( time ) )
		end

		if text then
			draw.MultilineText( width / 2, height * 0.09, text, "SCPAlphaDisplay", tc, width, 10, 5, TEXT_ALIGN_CENTER )
		end
	end
end