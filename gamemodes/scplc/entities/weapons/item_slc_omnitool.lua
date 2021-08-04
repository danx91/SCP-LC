SWEP.Base 			= "item_slc_base"
SWEP.Language 		= "OMNITOOL"

SWEP.ViewModel		= "models/weapons/alski/c_omnitool.mdl"
SWEP.WorldModel		= "models/weapons/alski/w_omnitool.mdl"

//SWEP.ShouldDrawWorldModel = false

SWEP.UseHands 		= true
SWEP.HoldType 		= "pistol"

//SWEP.Preparing = 0
//SWEP.ActionFinish = 0
SWEP.NextIdle = 0

//SWEP.Text = ""
//SWEP.ShowText = 0

SWEP.EjectWarn = 0

SWEP.LoadingDuration = 1.5

local STATE = {
	IDLE = 0,
	INSERTING = 1,
	INSTALLING = 2,
	EJECTING = 3,
	PREPARING = 4,
	USING = 5,
	ERROR = 6,
}

if CLIENT then
	SWEP.WepSelectIcon = Material( "slc/items/omnitool.png" )
	SWEP.SelectColor = Color( 255, 210, 0, 255 )
end

function SWEP:SetupDataTables()
	self:CallBaseClass( "SetupDataTables" )

	self:AddNetworkVar( "ChipID", "Int" )
	self:AddNetworkVar( "AccessOverride", "Int" )
	//self:AddNetworkVar( "State", "Int" )

	self:AddNetworkVar( "ShowText", "Float" )
	self:AddNetworkVar( "Text", "String" )

	self:NetworkVarNotify( "ChipID",  function( ent, name, old, new )
		if CLIENT then
			--ent:UpdateDescription( new )
		end
	end )

	self:ActionQueueSetup()
end

function SWEP:Initialize()
	//print( "Omnitool Init" )
	self:SetModelScale( 2 / 3 )

	self:SetHoldType( self.HoldType )
	self:InitializeLanguage()

	if CLIENT then
		self.CHIP_LANG = LANG.WEAPONS["ACCESS_CHIP"] or {}

		/*if !IsValid( self.WModel ) then
			self.WModel = ClientsideModel( self.WorldModel, RENDERGROUP_OPAQUE )
			self.WModel:SetParent( self )
			self.WModel:SetPos( self:GetPos() )
			self.WModel:SetNoDraw( true )

			local mx = Matrix()
			mx:Scale( self.WMScale )

			self.WModel:EnableMatrix( "RenderMultiply", mx )
		end*/

		self:UpdateDescription()
	end

	/*if CLIENT then
		local name = GetChipNameByID( self:GetChipID() )

		if name then
			if self.Lang.NAMES[name] then
				name = self.Lang.NAMES[name]
			end

			self.PrintName = string.format( self.Lang.cname, name )
		end
	end*/

	self:SetChipID( -1 )
	self:SetAccessOverride( 0 )
	self:SetState( STATE.IDLE )

	//self.ActionQueue = {}
	self:ActionQueueInit()
end

//SWEP.NOwner
function SWEP:Think()
	local ct = CurTime()
	local state = self:GetState()
	local owner = self:GetOwner()

	if self.NextIdle < ct then
		local vm = owner:GetViewModel()

		if IsValid( vm ) then
			local seq, time = vm:LookupSequence( "idle" )

			self.NextIdle = ct + time
			vm:SendViewModelMatchingSequence( seq )
		end
	end

	/*if state == STATE.IDLE then
		
	elseif state == STATE.PREPARING and self.Preparing < ct then
		self:SetState( STATE.IDLE )
	end*/

	self:ActionQueueThink()
end

function SWEP:Deploy()
	self:ResetAction( STATE.PREPARING, self.LoadingDuration )
	
	if CLIENT then
		self:ResetViewModelBones()
	end
end

function SWEP:Holster()
	local state = self:GetState()

	if state == STATE.INSERTING or state == STATE.EJECTING then
		return false
	end

	return true
end

function SWEP:Equip()
	self:CallBaseClass( "Equip" )

	if CLIENT then
		self:UpdateDescription()
	end
end

function SWEP:OnDrop()
	self:CallBaseClass( "OnDrop" )

	self.PreventDropping = false
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

SWEP.RPressed = 0
function SWEP:Reload()
	if self.RPressed < CurTime() then
		if self:GetState() == STATE.IDLE then
			if self:GetChipID() > -1 then
				if self.EjectWarn > CurTime() then
					self.EjectWarn = 0
					self:EjectChip()
				else
					self.EjectWarn = CurTime() + 2
				end
			end
		end
	end

	self.RPressed = CurTime() + 0.1
end

function SWEP:DragAndDrop( wep )
	if wep:GetClass() == "item_slc_access_chip" then
		local owner = self:GetOwner()
		if IsValid( owner ) and owner:GetActiveWeapon() == self then
			//if self:GetChipID() == -1 then
				if self:GetState() == STATE.IDLE then
					local chip = GetChipByID( wep:GetChipID() )
					if chip then
						self:InstallChip( chip, wep )
						return true
					end
				end
			//end
		end
	else
		return false
	end
end

/*function SWEP:QueueAction( state, duration, cb )
	table.insert( self.ActionQueue, { state = state, duration = duration, cb = cb } )

	if self.ActionFinish == 0 then
		self.ActionFinish = CurTime()
	end
end

function SWEP:ResetAction( state, duration )
	self.ActionQueue = {}

	self:SetState( state )
	self.ActionFinish = CurTime() + duration
end*/

function SWEP:PrintMessage( msg, dur )
	if !msg or msg == "" then return end

	//print( "Omnitool message!", msg )

	self:SetText( msg )
	self:SetShowText( CurTime() + ( dur or 2 ) )
end

//SWEP.UsingDoor = nil
function SWEP:UseOmnitool( ent, data, status, msg, shared )
	//print( "Omnitool use!", ent, data, status )

	local owner = self:GetOwner()
	if IsValid( owner ) then
		if SERVER and !shared then
			net.Ping( "SLCOmnitoolUsed", status, owner )
		end

		//if !status then
			//self:PrintMessage( "" )
			//return
		//end

		if self:GetState() == STATE.IDLE then
			local seq, dur = -1, 1

			local vm = owner:GetViewModel()
			if IsValid( vm ) then
				seq, dur = vm:LookupSequence( "use" )
			end

			dur = dur * 0.5

			self:QueueAction( STATE.USING, dur, function( time, duration )
				//if CLIENT then
					if seq > -1 then
						vm:SendViewModelMatchingSequence( seq )
						self.NextIdle = CurTime() + duration * 2
					end
				//end
			end )
			self:QueueAction( STATE.USING, dur, function( time, duration )
				if status then
					self:PrintMessage( msg or data.msg_access or "acc_granted" )

					if SERVER then
						if !isfunction( data.input_override ) or data.input_override( owner ) != true then
							//ent:Use( owner, owner, USE_TOGGLE )
							ent:Input( "Use", owner, owner )
						end

						//print( "granted!" )
						owner:EmitSound( "Omnitool.granted" )
					end

					--if IsValid( owner ) then
						--owner:EmitSound( "Omnitool.granted" )
					--end
				else
					self:PrintMessage( msg or data.msg_wrong or "acc_wrong" )

					--if IsValid( owner ) then
						if SERVER then
							owner:EmitSound( "Omnitool.denied" )
						end
						//owner:EmitSound( "Buttons.snd41" )
					--end
				end
			end )
		end
	end
end

function SWEP:InstallChip( chip, ent )
	if chip then
		local replace, override

		if self:GetChipID() != -1 then
			self:QueueAction( STATE.IDLE, 0, function( time, duration )
				if IsValid( ent ) then
					ent.PreventDropping = true
				end
			end )

			replace, override = self:EjectChip( true )
		end

		local owner = self:GetOwner()
		local seq, dur = -1, 2.33

		local vm = owner:GetViewModel()
		if IsValid( vm ) then
			seq, dur = vm:LookupSequence( "install" )
		end

		self:QueueAction( STATE.INSERTING, dur, function( time, duration )
			self.PreventDropping = true

			if IsValid( ent ) then
				ent.PreventDropping = true
			end

			if IsValid( vm ) then
				vm:SetSkin( chip.skin )
				if seq > -1 then
					vm:SendViewModelMatchingSequence( seq )
					self.NextIdle = CurTime() + duration
				end
			end
		end )

		self:QueueAction( STATE.INSTALLING, 2, function( time, duration )
			self:SetChipData( chip, ent:GetAccessOverride() )
			self.PreventDropping = false

			if CLIENT then
				self:UpdateDescription()
			end
			
			if IsValid( ent ) then
				ent.PreventDropping = false

				if SERVER then
					if replace then
						ent:SetChipData( replace, override )
					else
						ent:Remove()
					end
				end

				if CLIENT then
					if replace then
						ent:UpdateDescription( replace.id, override )
					end
				end
			end
		end  )
	end
end

function SWEP:EjectChip( swap )
	local id = self:GetChipID()
	if id != -1 then
		if self:GetState() == STATE.IDLE then
			local owner = self:GetOwner()
			if owner:HasWeapon( "item_slc_access_chip" ) and !swap then
				return false
			end

			local vm = owner:GetViewModel()
			if IsValid( vm ) then
				seq, dur = vm:LookupSequence( "extract" )
			end

			local chip = GetChipByID( id )
			local override = self:GetAccessOverride()

			self:QueueAction( STATE.EJECTING, dur, function( time, duration )
				self.PreventDropping = true

				if IsValid( vm ) then
					if chip then
						vm:SetSkin( chip.skin )
						if seq > -1 then
							vm:SendViewModelMatchingSequence( seq )
							self.NextIdle = CurTime() + duration
						end
					end
				end
			end )

			self:QueueAction( STATE.IDLE, 0, function( time, duration )
				if !swap then
					self.PreventDropping = false
					self:SetChipID( -1 )
					self:SetAccessOverride( 0 )

					if SERVER then
						if chip then
							if #owner:GetWeapons() < 8 and !owner:HasWeapon( "item_slc_access_chip" ) then
								local ent = owner:Give( "item_slc_access_chip" )
								ent:SetChipData( chip, override )
							else
								local ent = ents.Create( "item_slc_access_chip" )
								ent:SetChipData( chip, override )

								local ea = owner:GetAngles()
								local ang = Angle( 0, 0, 0 )
								ang.yaw = ea.yaw

								ent:SetAngles( ang )
								ent:SetPos( owner:GetShootPos() )

								ent:Spawn()
								ent.Dropped = CurTime()

								local phys = ent:GetPhysicsObject()
								if IsValid( phys ) then
									phys:SetVelocity( ea:Forward() * 300 )
								end
							end
						end
					end

					if CLIENT then
						self:UpdateDescription()
					end
				end
			end )

			return chip, override
		end
	end
end

function SWEP:SetChipData( chip, override )
	self:SetChipID( chip.id )
	self:SetAccessOverride( override or 0 )
end

function SWEP:HasAccess( acc )
	local id = self:GetChipID()
	if id > -1 then
		local chip = GetChipByID( id )
		if chip then
			return chip.obj:HasAccess( acc, self:GetAccessOverride() )
		end
	end

	return false
end

function SWEP:CanAccess( acc )
	if self:GetState() == STATE.IDLE then
		return self:HasAccess( acc )
	end

	return false
end

if CLIENT then
	--store most of the variables as local because they will be only visible to local player
	--also all these variables will be shared between different omnitools
	local screen_material = Material( "models/weapons/alski/omnitool/omnitool_screen" )

	local TEX_SIZE = 521
	local SCREEN_WIDTH, SCREEN_HEIGHT = 512, 340

	local screen_rt = GetRenderTarget( "SLCOmnitoolScreen", TEX_SIZE, TEX_SIZE )

	function SWEP:RenderScreen()
		screen_material:SetTexture( "$basetexture", screen_rt )

		render.PushRenderTarget( screen_rt )

			render.Clear( 3, 3, 3, 255, true )
			cam.Start2D()
				self:DrawOmnitoolScreen()
			cam.End2D()
		render.PopRenderTarget()
	end

	local COLOR = {
		white = Color( 255, 255, 255 ),
		gray = Color( 100, 100, 100 ),
	}

	local MATS = {
		logo = Material( "slc/misc/scp_logo_128.png" ),
	}

	local alpha = 0
	local hide = false
	function SWEP:DrawOmnitoolScreen()
		local w, h = SCREEN_WIDTH, SCREEN_HEIGHT

		local state = self:GetState()
		//if self.Preparing > CurTime() then
		if state == STATE.PREPARING then
			draw.Text( {
				text = self.Lang.SCREEN.loading.."...",
				pos = { w * 0.5, h * 0.3 },
				font = "SCPHUDVBig",
				color = COLOR.white,
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			})

			surface.SetDrawColor( COLOR.white )

			for i = 1, 3 do
				surface.DrawOutlinedRect( w * 0.1 - i, h * 0.5 - i, w * 0.8 + i * 2, h * 0.15 + i * 2 )
			end

			local t = self.ActionFinish - CurTime()

			if t < 0 then
				t = 0
			end

			local width = ( 1 - t / self.LoadingDuration ) * w * 0.8

			surface.SetDrawColor( COLOR.white )
			surface.DrawRect( w * 0.1, h * 0.5, width, h * 0.15 )

			if alpha > 0 then
				alpha = 0
			end

			return
		end

		if alpha < 1 then
			alpha = alpha + FrameTime()

			if alpha > 1 then
				alpha = 1
			end
		end

		surface.SetAlphaMultiplier( alpha )
		
		surface.SetDrawColor( COLOR.white )
		surface.SetMaterial( MATS.logo )
		surface.DrawTexturedRect( 32, 32, 128, 128 )

		draw.Text( {
			text = self.Lang.SCREEN.name,
			pos = { 512, 50 },
			font = "SCPHUDBig",
			color = Color( 255, 255, 255 ),
			xalign = TEXT_ALIGN_RIGHT,
			yalign = TEXT_ALIGN_CENTER,
		})

		draw.Text( {
			text = os.date( "%H:%M", os.time() ),
			pos = { 512, 340 },
			font = "SCPHUDBig",
			color = Color( 255, 255, 255 ),
			xalign = TEXT_ALIGN_RIGHT,
			yalign = TEXT_ALIGN_BOTTOM,
		})

		surface.SetAlphaMultiplier( 1 )

		if self.EjectWarn > CurTime() then
			draw.LimitedText( {
				text = self.Lang.SCREEN.ejectwarn,
				pos = { w * 0.5, h * 0.6 },
				font = "SCPHUDBig",
				color = Color( 255, 255, 255 ),
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
				max_width = SCREEN_WIDTH,
			})
			draw.LimitedText( {
				text = self.Lang.SCREEN.ejectconfirm,
				pos = { w * 0.5, h * 0.7 },
				font = "SCPHUDBig",
				color = Color( 255, 255, 255 ),
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
				max_width = SCREEN_WIDTH,
			})

			return
		end

		if state == STATE.INSTALLING then
			draw.LimitedText( {
				text = self.Lang.SCREEN.installing,
				pos = { w * 0.5, h * 0.6 },
				font = "SCPHUDVBig",
				color = Color( 255, 255, 255, math.TimedSinWave( 1, 0, 255 ) ),
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
				max_width = SCREEN_WIDTH,
			})
		elseif state == STATE.EJECTING then
			draw.LimitedText( {
				text = self.Lang.SCREEN.ejecting,
				pos = { w * 0.5, h * 0.6 },
				font = "SCPHUDVBig",
				color = Color( 255, 255, 255, math.TimedSinWave( 1, 0, 255 ) ),
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
				max_width = SCREEN_WIDTH
			})
		else
			surface.SetAlphaMultiplier( alpha )

			local show_text = self:GetShowText()
			if show_text > CurTime() then
				local text = self:GetText()

				if text and text != "" then
					if LANG.NRegistry[text] then
						text = LANG.NRegistry[text]
					end

					draw.MultilineText( 256, 140, text, "SCPHUDBig", Color( 255, 255, 255 ), SCREEN_WIDTH, 15, 0, TEXT_ALIGN_CENTER, 3 )
					surface.SetAlphaMultiplier( 1 )
					return
				end
			end

			draw.Text( {
				text = self.Lang.SCREEN.chip,
				pos = { 40, 180 },
				font = "SCPHUDVBig",
				color = Color( 255, 255, 255 ),
				xalign = TEXT_ALIGN_LEFT,
				yalign = TEXT_ALIGN_CENTER,
			})

			local name
			local id = self:GetChipID()
			if id > -1 then
				local chip = GetChipByID( id )
				if chip then
					name = self.CHIP_LANG.NAMES[chip.name] or id
				end
			end
			draw.LimitedText( {
				text = name or self.Lang.none,
				pos = { 70, 240 },
				font = "SCPHUDVBig",
				color = Color( 255, 255, 255 ),
				xalign = TEXT_ALIGN_LEFT,
				yalign = TEXT_ALIGN_CENTER,
				max_width = SCREEN_WIDTH - 75,
			})

			surface.SetAlphaMultiplier( 1 )
		end
	end

	function SWEP:ResetDrawAlpha()
		alpha = 0
	end

	function SWEP:UpdateDescription( id, override )
		id = id or self:GetChipID()

		local desc = StringBuilder()

		local chip = GetChipByID( id )
		if chip then
			desc:print( string.format( self.Lang.chip, self.CHIP_LANG.NAMES[chip.name] or id ) )
			desc:print( string.format( self.Lang.clearance, chip.level ) )

			local cd = GetChipDescription( chip.name, override or self:GetAccessOverride(), self.CHIP_LANG.ACCESS, false )
			if cd then
				desc:print( string.format( "%s\n\t%s", self.CHIP_LANG.hasaccess, cd ) )
			end
		else
			desc:print( string.format( self.Lang.chip, self.Lang.none ) )
		end

		desc:trim( true )
		self.Info = tostring( desc )
	end

	SWEP.BoneAttachment = "ValveBiped.Bip01_R_Hand"
	SWEP.PosOffset = Vector( 4, -3.5, -4 )
	SWEP.AngOffset = Angle( -90, 0, 0 )
	//SWEP.WMScale = Vector( 0.667, 0.667, 0.667 )

	function SWEP:DrawWorldModel()
		local owner = self:GetOwner()

		if IsValid( owner ) then
			/*local wm = self.WModel

			if !IsValid( wm ) then
				print( "OMNITOOL WM NOT VALID!!!" )
				return
			end*/

			local bone = owner:LookupBone( self.BoneAttachment )
			if bone then
				local matrix = owner:GetBoneMatrix( bone )
				if matrix then
					local pos, ang = LocalToWorld( self.PosOffset, self.AngOffset, matrix:GetTranslation(), matrix:GetAngles() )

					/*wm:SetPos( pos )
					wm:SetAngles( ang )
					wm:SetupBones() --remove?
					wm:DrawModel()*/
					self:SetRenderOrigin( pos )
					self:SetRenderAngles( ang )
					self:SetupBones()

					self:DrawModel()
				end
			end
		else
			self:SetRenderOrigin()
			self:SetRenderAngles()
			self:SetupBones()

			self:DrawModel()
		end
	end

	net.ReceivePing( "SLCOmnitool", function( data )
		local ply = LocalPlayer()
		local omnitool = ply:GetWeapon( "item_slc_omnitool" )

		if IsValid( omnitool ) then
			omnitool:UseOmnitool( nil, nil, data == "true" )
		end
	end )
end

InstallTable( "ActionQueue", SWEP )

sound.Add{
	name = "Omnitool.granted",
	sound = "scp_lc/misc/omnitool_granted.ogg",
	volume = 0.2,
	level = 60,
	pitch = 100,
	channel = CHAN_STATIC,
}

sound.Add{
	name = "Omnitool.denied",
	sound = "buttons/combine_button1.wav",
	volume = 0.4,
	level = 60,
	pitch = 100,
	channel = CHAN_STATIC,
}

/*concommand.Add( "giveomni", function( ply, cmd, args )
	if SERVER then
		ply:Give( "item_slc_omnitool" )
	end
end )*/