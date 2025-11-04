AddCSLuaFile()

ENT.Base = "slc_display_base"
ENT.Model = "models/props/alski/warhead_screen.mdl"

local STATE_IDLE = 0
local STATE_WAITING = 1
local STATE_FAILED = 2
local STATE_NOREMOTE = 3
local STATE_COUNTDOWN = 4
local STATE_NONE = 5

function ENT:SetupDataTables()
	self:NetworkVar( "Int", "State" )
	self:NetworkVar( "Float", "Time" )
end

ENT.Waiting = 0
function ENT:Think()
	if SERVER then
		local ct = CurTime()
		local state = self:GetState()

		if state != STATE_COUNTDOWN and state != STATE_NONE and GetRoundStat( "omega_warhead" ) then
			self.Waiting = 0

			self.Usable = false
			self:SetState( STATE_COUNTDOWN )
			self:SetTime( ct + CVAR.slc_time_omega:GetInt() + 3 )
		end

		if state == STATE_WAITING and self.Waiting <= ct then
			self.Listener:Broadcast( self, true, 0, self.NUse )
		end

		if ( state == STATE_FAILED or state == STATE_NOREMOTE ) and self.NUse <= ct then
			self:SetState( STATE_IDLE )
		end
	end
end

function ENT:AccessOverride( ply, data )
	if !self.Usable or self.NUse > CurTime() then
		return false, ""
	end
end

function ENT:OnUse( ply )
	self:SetState( STATE_WAITING )
	self.Waiting = CurTime() + 2
	self.Listener:Trigger( ply, self, self.ID )
end

function ENT:SetData( listener, id )
	self.Listener = listener
	self.ID = id
end

function ENT:DataBroadcast( ent, t, what, time )
	if t == SEL_USER then
		if what == 0 then
			self.NUse = time
			self:SetTime( time )
			self:SetState( STATE_FAILED )
		elseif what == 1 then
			self.NUse = CurTime() + 5
			self:SetState( STATE_NOREMOTE )
		elseif what == 2 then
			self.Usable = false
			self:SetState( STATE_NONE )
		end
	end
end

if CLIENT then
	local tc = Color( 175, 175, 175, 255 )

	function ENT:RenderScreen( width, height )
		local state = self:GetState()
		if state == STATE_NONE then return end

		local time = self:GetTime() - CurTime()
		if time < 0 then
			time = 0
		end

		local text
		if state == STATE_IDLE then
			text = LANG.MISC.omega_warhead.idle
		elseif state == STATE_WAITING then
			text = LANG.MISC.omega_warhead.waiting
		elseif state == STATE_FAILED then
			text = string.format( LANG.MISC.omega_warhead.failed, math.ceil( time ) )
		elseif state == STATE_NOREMOTE then
			text = LANG.MISC.omega_warhead.no_remote
		elseif state == STATE_COUNTDOWN then
			text = string.format( LANG.MISC.omega_warhead.active, time )
		end

		if text then
			draw.MultilineText( width / 2, height * 0.09, text, "SCPOmegaDisplay", tc, width, 10, 5, TEXT_ALIGN_CENTER )
		end
	end

	hook.Add( "RebuildFonts", "SLCOmegaFont", function()
		surface.CreateFont( "SCPOmegaDisplay", {
			font = "Impacted",
			size = 52,
			antialias = true,
			weight = 500,
			extended = true,
		} )
	end )
end