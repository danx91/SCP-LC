local ply = FindMetaTable( "Player" )

--[[-------------------------------------------------------------------------
General Functions
---------------------------------------------------------------------------]]
function ply:SetSCPClass( class )
	if !self.Set_SCPClass then
		self:DataTables()
	end

	self:Set_SCPClass( class )
	self:Set_SCPPersonaC( class )
end

function ply:Cleanup( norem )
	hook.Run( "SLCPlayerCleanup", self )

	self:RemoveEffect()
	self:RemoveEFlags( EFL_NO_DAMAGE_FORCES )

	self.SetupAsSpectator = nil //TODO move to properties
	self.DeathScreen = nil //TODO move to properties
	self.ClassData = nil

	self:ResetProperties()
	self.SLCProperties = {}
	self:ClearSpeedStack()
	self.PlayerData:Reset()
	self.Logger:Reset()

	self:SetStamina( 100 )
	self:SetMaxStamina( 100 )
	self:SetStaminaLimit( 100 )
	self:SetDisableControlsFlag( 0 )
	self:SetDisableControls( false )

	self:SetRenderMode( RENDERMODE_NORMAL )
	self:SetColor( Color( 255, 255, 255 ) )
	self:SetSubMaterial()
	self:SetMaterial( "" )

	self:SetSkin( 0 )
	for i = 1, self:GetNumBodyGroups() do
		self:SetBodygroup( i, 0 )
	end

	self:SetDSP( 1 )
	self:SetModelScale( 1 )
	self:Freeze( false )
	self:SetNoDraw( false )
	self:SetCustomCollisionCheck( false )
	self:StopBurn()

	self:StopAmbient()

	if !norem then
		self:SetVest( 0 )
		self:RemoveAllItems()
	end

	local sig = math.floor( CurTime() )
	self:SetTimeSignature( sig )

	net.Ping( "SLCPlayerSync", sig, self )

	net.Start( "PlayerCleanup" )
	net.WriteEntity( self )
	net.Broadcast()
end

function ply:Despawn()
	self:Cleanup()
	self:InvalidatePlayerForSpectate()
end

/*function ply:PrepareForSpawn()
	self:UnSpectate()
	//self:InvalidatePlayerForSpectate()

end*/

function ply:DropEQ()
	self:DropVest( true )

	for k, wep in pairs( self:GetWeapons() ) do
		self:PlayerDropWeapon( wep:GetClass(), true, true )
	end
end

local function setup_player_internal( self, class, spawn )
	self:UnSpectate()
	self:Cleanup()

	self:Spawn()
	self:SetPos( spawn )

	self:Flashlight( false )
	self:AllowFlashlight( false )
	self:SetArmor( 0 )

	self:SetSCPClass( class.name )
	self:SetSCPTeam( class.team )

	if class.persona and class.persona.class then
		self:Set_SCPPersonaC( class.persona.class )
	end

	if class.persona and class.persona.team then
		self:Set_SCPPersonaT( class.persona.team )
	end

	self:Give( "item_slc_holster" )
	self:Give( "item_slc_id" )

	local chip = GetChip( class.chip )
	if class.omnitool then
		local omnitool = self:Give( "item_slc_omnitool" )
		if IsValid( omnitool ) and chip then
			omnitool:SetChipData( chip, GenerateOverride( chip ) )
		end
	elseif chip then
		/*local keycard = self:Give( "item_slc_keycard" )
		if IsValid( keycard ) then
			keycard:SetKeycardType( class.chip )
		end*/
		local wep = self:Give( "item_slc_access_chip" )
		if IsValid( wep ) then
			wep:SetChipData( chip )
		end
	end

	for i, v in ipairs( class.weapons ) do
		if istable( v ) then
			v = table.Random( v )
		end

		local wep = self:Give( v )

		if IsValid( wep ) then
			local ammo = class.ammo[v]

			if ammo then
				local clip = math.min( ammo, wep:GetMaxClip1() )
				local reserve = ammo - clip

				wep:SetClip1( clip )

				if reserve > 0 then
					self:GiveAmmo( reserve, wep:GetPrimaryAmmoType() )
				end
			end
		else
			print( "Failed to create weapon: "..v )
		end
	end

	self:SetMaxHealth( class.health )
	self:SetHealth( class.health )

	self:SetMaxSanity( class.max_sanity or class.sanity )
	self:SetSanity( class.sanity )

	self:SetBaseSpeed( class.walk_speed, class.run_speed, 0.5 )
	self:SetJumpPower( 175 )

	local max_stamina = class.stamina or 100
	self:SetStamina( max_stamina )
	self:SetMaxStamina( max_stamina )
	self:SetStaminaLimit( max_stamina )

	self:SetModel( istable( class.model ) and table.Random( class.model ) or class.model )

	if class.skin then
		self:SetSkin( class.skin )
	end

	if class.bodygroups then
		for k, v in pairs( class.bodygroups ) do
			if isstring( k ) then
				k = self:FindBodygroupByName( k )
			end

			if k > -1 then
				self:SetBodygroup( k, v )
			end
		end
	end

	self:SetupHands()

	self.ClassData = class

	hook.Run( "SLCPlayerSetup", self )

	if class.vest then
		self:EquipVest( class.vest, true )
	end

	/*net.Start( "PlayerSetup" )
	net.Send( self )*/
end

function ply:SetupPlayer( class, spawn, instant )
	if instant then
		setup_player_internal( self, class, spawn )
	else
		self:KillSilent()
		self:UnSpectate()
		self:SetPos( ZERO_POS )

		self:SetSCPClass( class.name )
		self:SetSCPTeam( class.team )
		//self:InvalidatePlayerForSpectate()

		self:SetProperty( "spawning", { time = CurTime() + INFO_SCREEN_DURATION, class = class, spawn = spawn } )
		//info screen
		InfoScreen( self, "spawn", INFO_SCREEN_DURATION )
	end
end

hook.Add( "Tick", "SLCSpawnTick", function()
	local ct = CurTime()

	for k, v in pairs( player.GetAll() ) do
		local data = v:GetProperty( "spawning" )
		if data and data.time < ct then
			v:SetProperty( "spawning", nil )
			setup_player_internal( v, data.class, data.spawn )
		end
	end
end )

function ply:EquipVest( vest, silent )
	if self:GetVest() > 0 then return end

	local t = self:SCPTeam()
	if t == TEAM_SPEC then return end
	if t == TEAM_SCP and !self:GetSCPHuman() then return end

	if isstring( vest ) then
		vest = VEST.GetID( vest )
	end

	local data = VEST.GetData( vest )
	if data then
		if !hook.Run( "SLCArmorPickedUp", self ) then
			self:SetVest( vest )
			//self.OldModel = self:GetModel()

			//local custom = {}
			local use_model
			local callback = VEST.GetCallback( vest )
			if callback then
				use_model = callback( self, vest, data )
			end

			local bodygroups = {}
			for i = 0, self:GetNumBodyGroups() - 1 do
				bodygroups[i] = self:GetBodygroup( i )
			end

			self:SetProperty( "old_model", { self:GetModel(), self:GetSkin(), bodygroups } )
			self:SetModel( use_model or istable( data.model ) and table.Random( data.model ) or data.model )

			if data.skin then
				self:SetSkin( data.skin )
			end

			if data.bodygroups then
				for k, v in pairs( data.bodygroups ) do
					if isstring( k ) then
						k = self:FindBodygroupByName( k )
					end

					if k > -1 then
						self:SetBodygroup( k, v )
					end
				end
			end

			/*local callback = VEST.GetCallback( vest )
			if callback then
				callback( self, vest, data, true, custom )
			end*/

			self:PushSpeed( data.mobility, data.mobility, -1, "SLC_Vest" )

			if !silent then
				PlayerMessage( "vestpickup", self )
				self:EmitSound( "SLCPlayer.Vest" )
			end

			return true
		end
	end
end

function ply:DropVest( silent )
	local vest = self:GetVest()
	if vest == 0 then return end

	local info = self:GetProperty( "old_model" )
	if !info then
		print( "ERROR! Failed to retrieve player model!" )
		if !self.ClassData then
			ErrorNoHalt(  "FATAL ERROR! Essential playerdata is missing! It should NEVER happen!" )
			return
		end

		info = { istable( self.ClassData.model ) and table.Random( self.ClassData.model ) or self.ClassData.model, self.ClassData.skin, self.ClassData.bodygroups }
	end

	self:SetVest( 0 )

	local pos = self:GetPos():DropToFloor()
	VEST.Create( vest, pos )

	self:SetModel( info[1] )

	if info[2] then
		self:SetSkin( info[2] )
	end

	if info[3] then
		for k, v in pairs( info[3] ) do
			if isstring( k ) then
				k = self:FindBodygroupByName( k )
			end

			if k > -1 then
				self:SetBodygroup( k, v )
			end
		end
	end

	self:SetProperty( "old_model" )
	//self.OldModel = nil

	/*if !self.VestSpeed then
		print( "ERROR! Failed to restore player speed! It can cause speed errors!" )
	else
		self:PopSpeed( self.VestSpeed )
		self.VestSpeed = nil
	end*/
	self:PopSpeed( "SLC_Vest" )

	if !silent then
		PlayerMessage( "vestdrop", self )
		self:EmitSound( "SLCPlayer.Vest" )
	end

	hook.Run( "SLCArmorDropped", self )
end

/*local function applyDifference( base, tab, new )
	if !istable( base ) then return end

	for k, v in pairs( base ) do
		if istable( v ) and istable( tab[k] ) then
			applyDifference( v, tab[k], new[k] )
		else
			if tab[k] != v then
				new[k] = tab[k]
			end
		end
	end
end*/

function ply:CreatePlayerRagdoll()
	if self:GetSCPNoRagdoll() then return end
	if self:GetNoDraw() then return end

	local rag = ents.Create( "prop_ragdoll" )
	rag:SetPos( self:GetPos() )
	rag:SetAngles( self:GetAngles() )

	rag:SetModel( self:GetModel() )
	rag:SetColor( self:GetColor() )
	rag:SetMaterial( self:GetMaterial() )

	rag:SetOwner( self )

	for i, v in ipairs( rag:GetMaterials() ) do
		local mat = self:GetSubMaterial( i - 1 )

		if mat != "" then
			rag:SetSubMaterial( i - 1, mat )
		end
	end

	rag:Spawn()

	/*local phys = rag:GetPhysicsObject()
	if !IsValid( phys ) then
		print( "Physics Object Invalid", self, self:GetModel() )
		rag:Remove()
		return
	end*/

	rag:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )

	local vel = self:GetVelocity()
	for i = 0, rag:GetPhysicsObjectCount() do
		local physobj = rag:GetPhysicsObjectNum( i )

		if IsValid( physobj ) then
			local pos, ang = self:GetBonePosition( rag:TranslatePhysBoneToBone( i ) )

			if pos and ang then
				physobj:SetPos( pos )
				physobj:SetAngles( ang )
			end

			physobj:SetVelocity( vel * 0.2 )
		end
	end

	rag:SetNWInt( "time", CurTime() )
	rag:SetNWInt( "team", self:SCPTeam() )

	rag.Data = {
		time = CurTime(),
		team = self:SCPTeam(),
		class = self:SCPClass(),
		persona = { self:SCPPersona() },
	}

	self._RagEntity = rag
	return rag
end

function ply:Blink( dur, nextblink )
	if !self:GetBlink() then
		self:SetBlink( true )

		net.Start( "PlayerBlink" )
			net.WriteFloat( dur )
			net.WriteUInt( nextblink, 6 )
		net.Send( self )

		Timer( "PlayerUnBlink"..self:SteamID64(), math.max( dur, 0.4 ), 1, function()
			if IsValid( self ) then
				self:SetBlink( false )
			end
		end )

		hook.Run( "SLCBlink", dur, nextblink )
	end
end

--[[-------------------------------------------------------------------------
Premium
---------------------------------------------------------------------------]]
_OldSetUserGroup = _OldSetUserGroup or ply.SetUserGroup
function ply:SetUserGroup( ... )
	_OldSetUserGroup( self, ... )
	self:CheckPremium()
end

cvars.AddChangeCallback( CVAR.slc_premium_groups:GetName(), function( cvar, old, new )
	for k, v in pairs( player.GetAll() ) do
		v:CheckPremium()
	end
end, "PremiumGroups" )

function ply:CheckPremium()
	if !self.PlayerData then return end

	local groups = {}
	//for s in string.gmatch( string.gsub( CVAR.slc_premium_groups:GetString(), "%s", "" ), "[^,]+" ) do
	for s in string.gmatch( CVAR.slc_premium_groups:GetString(), "[^,]+" ) do
		table.insert( groups, string.Trim( s ) )
	end

	local premium = false

	local group = self:GetUserGroup()
	local useulib = ULib != nil

	for i, v in ipairs( groups ) do
		if useulib and self:CheckGroup( v ) or v == group then
			premium = true
			break
		end
	end

	self:SetPremium( premium )
end

--[[-------------------------------------------------------------------------
SPEED SYSTEM
---------------------------------------------------------------------------]]
function ply:PushSpeed( walk, run, crouch, id, maxstack )
	if walk <= 0 and walk != -1 then
		print( "Inavlid value for walk speed!" )
		return false
	end

	if run <= 0 and run != -1 then
		print( "Inavlid value for run speed!" )
		return false
	end

	if crouch < 0 and crouch != -1 then
		crouch = 0
	elseif crouch > 1 then
		crouch = 1
	end

	if self.SpeedStack then
		if type( id ) == "string" then
			for i, v in ipairs( self.SpeedStack ) do
				if v.id == id then
					if !maxstack or maxstack == -1 or !isnumber( maxstack ) or v.stacks < maxstack then
						v.stacks = v.stacks + 1
					end

					return true
				end
			end
		else
			id = nil
		end
	end

	local swalk = self:GetWalkSpeed()
	local srun = self:GetRunSpeed()
	local scrouch = self:GetCrouchedWalkSpeed()

	if !self.SpeedStack then
		self.SpeedStack = { {
			id = 0,
			spid = 0,
			walk = swalk,
			run = srun,
			crouch = scrouch,
		} }
	end

	if walk > 0 and walk <= 2 then
		self:SetWalkSpeed( swalk * walk )
	elseif walk != -1 then
		self:SetWalkSpeed( walk )
	end

	if run > 0 and run <= 2 then
		self:SetRunSpeed( srun * run )
	elseif run != -1 then
		self:SetRunSpeed( run )
	end


	if crouch != -1 then
		self:SetCrouchedWalkSpeed( crouch )
	end

	local spid = self.SpeedStack[#self.SpeedStack].spid + 1
	if !id then
		id = spid
	end

	table.insert( self.SpeedStack, { id = id, spid = spid, walk = walk, run = run, crouch = crouch, stacks = 1 } )

	return id
end

/*local function getFirstValue( ply, id )
	for i = #ply.SpeedStack - 1, 1, -1 do
		local var = ply.SpeedStack[i][id]
		
		if var != -1 then
			if id != "crouch" and var > 0 and var <= 1 then
				local tmp = table.remove( ply.SpeedStack, i )
				local nv = getFirstValue( ply, id )

				table.insert( ply.SpeedStack, i, tmp )

				return nv * var
			end

			return var
		end
	end
end*/

local function getCrouchValue( p )
	for i, v in rpairs( p.SpeedStack ) do
		local value = v.crouch

		if value != -1 then
			return value
		end
	end
end

local function getSpeedValue( p, id )
	local mul = 1

	for i, v in rpairs( p.SpeedStack ) do
		local value = v[id]

		if value > 0 and value <= 2 then
			mul = mul * value
		elseif value >= 3 then
			return value * mul
		end
	end
end

function ply:PopSpeed( id, all )
	if !self.SpeedStack then return end
	if id == 0 then return end

	for i, v in ipairs( self.SpeedStack ) do
		if v.id == id then
			v.stacks = v.stacks - 1

			if all or v.stacks <= 0 then
				/*if i == #self.SpeedStack then
					self:SetWalkSpeed( getFirstValue( self, "walk" ) )
					self:SetRunSpeed( getFirstValue( self, "run" )  )
					self:SetCrouchedWalkSpeed( getFirstValue( self, "crouch" ) )
				end*/

				table.remove( self.SpeedStack, i )

				self:SetWalkSpeed( getSpeedValue( self, "walk" ) )
				self:SetRunSpeed( getSpeedValue( self, "run" )  )
				self:SetCrouchedWalkSpeed( getCrouchValue( self ) )

				return true
			end

			return false
		end
	end
end

function ply:SetBaseSpeed( walk, run, crouch )
	if !self.SpeedStack then
		self.SpeedStack = {}
	end

	self.SpeedStack[1] = {
		id = 0,
		spid = 0,
		walk = walk,
		run = run,
		crouch = crouch
	}

	if #self.SpeedStack == 1 then
		self:SetWalkSpeed( walk )
		self:SetRunSpeed( run )
		self:SetCrouchedWalkSpeed( crouch )
	end
end

function ply:ClearSpeedStack()
	if !self.SpeedStack then return end

	self:SetWalkSpeed( self.SpeedStack[1].walk )
	self:SetRunSpeed( self.SpeedStack[1].run )
	self:SetCrouchedWalkSpeed( self.SpeedStack[1].crouch )

	self.SpeedStack = { self.SpeedStack[1] }
end

/*PrintTable( Entity( 1 ).SpeedStack )
print( "walk", Entity( 1 ):GetWalkSpeed() )
print( "run", Entity( 1 ):GetRunSpeed() )*/

--[[-------------------------------------------------------------------------
Weapons
---------------------------------------------------------------------------]]
function ply:PlayerDropWeapon( class, all, force )
	local wep = self:GetWeapon( class )

	if IsValid( wep ) then
		if wep.Droppable == false then return end
		if !force and ( wep.PreventDropping == true or wep.CanDrop and wep:CanDrop() == false ) then return end

		if wep.Stacks and wep.Stacks > 1 then
			local count = wep:GetCount()

			if count > 1 then
				local forward = self:EyeAngles():Forward()

				for i = 1, all and count or 1 do
					local new = ents.Create( class )

					if IsValid( new ) then
						new:SetPos( self:GetShootPos() + forward * 10 )
						new:SetAngles( self:GetAngles() )
						new:Spawn()

						new.Dropped = CurTime()

						local phys = new:GetPhysicsObject()
						if IsValid( phys ) then
							phys:SetVelocity( forward * 300 + VectorRand() * 10 )
						end
					end

					wep:RemoveStack()
				end

				return
			end
		end

		//print( wep:Clip1(), self:GetAmmoCount( wep:GetPrimaryAmmoType() ) )
		if wep.SLCPreDrop then
			wep:SLCPreDrop()
		end

		self:DropWeapon( wep )
		wep.Dropped = CurTime()
		/*if wep.OnDrop then
			wep:OnDrop()
		end*/
	end
end

function ply:StoreWeapon( class )
	local wep = self:GetWeapon( class )

	if IsValid( wep ) then
		local data = {
			class = wep:GetClass(),
			clip1 = wep:Clip1(),
			clip2 = wep:Clip2(),
		}

		if wep.StoreWeapon then
			wep:StoreWeapon( data, self )
		end

		wep:Remove()

		return data
	end
end

function ply:StoreWeapons()
	local data = {}

	for k, v in pairs( self:GetWeapons() ) do
		local class = v:GetClass()
		data[class] = self:StoreWeapon( class )
	end

	return data
end

function ply:RestoreWeapon( data )
	local class = data.class

	local wep = self:Give( class )
	if IsValid( wep ) then
		wep:SetClip1( data.clip1 )
		wep:SetClip2( data.clip2 )

		if wep.RestoreWeapon then
			wep:RestoreWeapon( data, self )
		end

		return wep
	end
end

function ply:RestoreWeapons( tab )
	for k, v in pairs( tab ) do
		self:RestoreWeapon( v )
	end
end

--[[-------------------------------------------------------------------------
Statis
---------------------------------------------------------------------------]]
--REVIEW: Is ammo stored by default?
function ply:SetStasis( time )
	local data = {}

	//hook.Run( "SLCCreateStasisData", self, data )

	data.signature = self:TimeSignature()

	data.max_health = self:GetMaxHealth()
	data.health = self:Health()

	data.weapons = self:StoreWeapons()

	hook.Run( "SLCPlayerStasisStart", self, data )
	self:SetProperty( "stasis_data", data )

	self:CreatePlayerRagdoll()
	//self:CreateRagdoll()

	--Soft cleanup
	self:ClearSpeedStack()
	self:RemoveEffect()
	self:StopBurn()
	self:StopAmbient()

	--Don't trigger death hooks
	self:KillSilent()

	//hook.Run( "SLCPlayerStasisStart", self, data )

	if time and time > 0 then
		AddTimer( "Stasis_"..self:SteamID64(), time, 1, function( this, n )
			if IsValid( self ) then
				local s_data = self:GetProperty( "stasis_data" )
				if s_data and self:CheckSignature( s_data.signature ) then
					self:DisableStasis()
				end
			end
		end )
	end
end

function ply:DisableStasis()
	local data = self:GetProperty( "stasis_data" )
	self:SetProperty( "stasis_data", nil )

	if data and self:CheckSignature( data.signature ) then
		self:UnSpectate()
		self:Spawn()

		self:SetMaxHealth( data.max_health or 100 )
		self:SetHealth( data.health or 100 )

		self:RestoreWeapons( data.weapons )

		local sig = math.floor( CurTime() )
		self:SetTimeSignature( sig )
		net.Ping( "SLCPlayerSync", sig, self )

		hook.Run( "SLCPlayerStasisEnd", self, data )
	end
end

--[[-------------------------------------------------------------------------
AFK
---------------------------------------------------------------------------]]
function ply:MakeAFK()
	if !self:IsAFK() then
		self.SLCAFKTimer = RealTime() + 1
		self:Set_SCPAFK( true )
		PlayerMessage( "afk", self )
	end
end

//local nafk = 0
Timer( "SLCAFKCheck", 10, 0, function( self, n )
	local rt = RealTime()
	local afk_time = CVAR.slc_afk_time:GetInt() or 60
	local afk_mode = CVAR.slc_afk_mode:GetInt() or 1

	local players = player.GetAll()
	local server_full = #players == game.MaxPlayers()


	for k, v in pairs( players ) do
		if !v:IsBot() then
			if !v:IsAFK() then
				--print( "check", v, v.SLCAFKTimer, rt )
				if v.SLCAFKTimer and v.SLCAFKTimer + afk_time < rt then
					v:MakeAFK()
				end
			elseif SLCAuth.HasAccess( v, "slc afkdontkick" ) then
				--print( "Player afk", v, math.floor( rt - v.SLCAFKTimer ) )

				if afk_mode == 1 and server_full then
					print( "AFK player kicked - Server is full" )
					v:Kick( "AFK" )
				elseif afk_mode >= 2 then
					if math.floor( rt - v.SLCAFKTimer ) >= afk_mode then
						print( "AFK player kicked - Maximum AFK time exceded" )
						v:Kick( "AFK" )
					end
				end
			end
		end
	end
end )

--[[-------------------------------------------------------------------------
SLCProperties
---------------------------------------------------------------------------]]
function ply:ResetProperties()
	self.SLCProperties = {}
end

function ply:SetProperty( key, value )
	if !self.SLCProperties then self.SLCProperties = {} end

	self.SLCProperties[key] = value
	return value
end

function ply:GetProperty( key )
	if !self.SLCProperties then self.SLCProperties = {} end

	return self.SLCProperties[key]
end

--[[-------------------------------------------------------------------------
SLCTask
---------------------------------------------------------------------------]]
function ply:IsDoingSLCTask( name )
	local task = self:GetProperty( "slc_task" )

	if name then
		return task and task.name == name
	else
		return !!task
	end
end

function ply:StartSLCTask( name, time, check, show_bar, block_movement, args )
	local promise = Promise( function( resolve, reject )
		if self:IsDoingSLCTask() then
			self:StopSLCTask( 2 )
		end

		local end_time = CurTime() + time
		local old_flag = self:GetDisableControlsFlag()

		self:SetProperty( "slc_task", {
			name = name,
			end_time = end_time,
			resolve = resolve,
			reject = reject,
			check = check,
			block_movement = block_movement,
			show_bar = show_bar,
			was_blocked = self:GetDisableControls(),
			blocked_flag = old_flag,
			args = args,
		} )

		if show_bar then
			local bar_name

			if isstring( show_bar ) then
				bar_name = show_bar
			end

			self:EnableProgressBar( true, end_time, bar_name )
		end

		if block_movement then
			self:SetDisableControls( true )

			if isnumber( block_movement ) then
				self:SetDisableControlsFlag( bit.bor( old_flag, block_movement ) )
			end
		end
	end )

	return promise
end

function ply:StopSLCTask( data )
	local task = self:GetProperty( "slc_task" )
	if task.show_bar then
		self:EnableProgressBar( false )
	end

	if task.block_movement then
		local cur = self:GetDisableControls()

		if !cur or !task.was_blocked then
			self:SetDisableControls( false )
			self:SetDisableControlsFlag( 0 )
		else
			self:SetDisableControlsFlag( task.blocked_flag )
		end
	end

	if data then
		task.reject( data )
	end

	self:SetProperty( "slc_task", nil )
end

hook.Add( "Tick", "SLCTaskTick", function()
	local ct = CurTime()

	for k, v in pairs( player.GetAll() ) do
		local data = v:GetProperty( "slc_task" )
		if data then
			if data.end_time <= ct then
				data.resolve( data.args )
				v:StopSLCTask()
			elseif data.check then
				if !data.check() then
					v:StopSLCTask( 1 )
				end
			end
		end
	end
end )

--[[-------------------------------------------------------------------------
Progress Bar Binding
---------------------------------------------------------------------------]]
function ply:EnableProgressBar( enable, endtime, text )
	ProgressBar( self, enable, endtime, text )
end

--[[-------------------------------------------------------------------------
Helper functions
---------------------------------------------------------------------------]]
Player_AddFrags = Player_AddFrags or ply.AddFrags

function ply:AddFrags( f )
	if f > 0 then
		local team = self:SCPTeam()
		if team != TEAM_SPEC then
			SCPTeams.AddScore( team, f )
		end
	end

	Player_AddFrags( self, f )
end

function ply:SetPrestigePoints( pp )
	self:Set_SCPPrestigePoints( pp )
	self:SetSCPData( "prestige_points", pp )
end

function ply:AddPrestigePoints( pp )
	self:SetPrestigePoints( self:Get_SCPPrestigePoints() + pp )
end

function ply:SetPrestige( p )
	self:Set_SCPPrestige( p )
	self:SetSCPData( "prestige", p )
end

function ply:AddPrestige( p )
	local cur = self:Get_SCPPrestige()
	local new = cur + p

	if new > 9999 then
		p = p - new + 9999
		new = 9999
	end

	if p > 0 and new > cur then
		self:SetPrestige( cur + p )
		self:AddPrestigePoints( p * 5 )
	end
end

function ply:SetSCPLevel( lvl )
	self:Set_SCPLevel( lvl )
	self:SetSCPData( "level", lvl )
end

function ply:AddLevel( lvl )
	if lvl >= 0 then
		local pu = false
		local level = self:Get_SCPLevel() + lvl

		if level >= 10 then
			local p = math.floor( level / 10 )
			level = level - p * 10

			self:AddPrestige( p )
			PlayerMessage( "prestigeup$"..EscapeMessage( self:Nick() )..","..self:SCPPrestige().."#255,250,75" )

			pu = true
		end

		self:SetSCPLevel( level )
		self:AddPrestigePoints( lvl )

		return pu
	end
end

function ply:AddXP( xp )
	if !isnumber( xp ) then return end

	local lvlxp = CVAR.slc_xp_level:GetInt()
	local lvlinc = CVAR.slc_xp_increase:GetInt()

	self:AddLevel( 0 ) --prestige up check

	local plyxp = self:SCPExp()
	local level = self:SCPLevel()
	local prestige = self:SCPPrestige()

	local ref = { 1 }

	if self:IsPremium() then
		ref[1] = ref[1] + CVAR.slc_premium_xp:GetFloat() - 1
	end

	hook.Run( "SLCScaleXP", self, ref )

	xp = math.floor( xp * ref[1] )
	plyxp = plyxp + xp

	local req = lvlxp + lvlinc * prestige
	local lvls = 0

	while plyxp >= req do
		plyxp = plyxp - req
		lvls = lvls + 1

		if level + lvls >= 10 then --this shouldn't be ever greater than 10 because of prestige check few lines above
			//local p = math.floor( level / 10 )
			//level = level - p * 10
			prestige = prestige + 1
			level = level - 10

			req = lvlxp + lvlinc * prestige
		end
	end

	/*if plyxp >= req then
		plyxp = plyxp - req

		if !self:AddLevel( 1 ) then
			PlayerMessage( "levelup$"..self:SCPLevel(), self )
		end
	end*/

	self:AddLevel( lvls )

	self:Set_SCPExp( plyxp )
	self:SetSCPData( "xp", plyxp )

	return xp
end

function ply:AddSanity( s )
	local sanity = self:GetSanity()
	local maxsanity = self:GetMaxSanity()

	self:SetSanity( math.Clamp( sanity + s, 0, maxsanity ) )

	/*if sanity / maxsanity < 0.1 and !self:HasEffect( "insane" ) then
		self:ApplyEffect( "insane" )
	end*/
end

function ply:AddHealth( num )
	local max = self:GetMaxHealth()
	local hp = self:Health() + num

	if hp > max then
		hp = max
	end

	self:SetHealth( hp )

	return hp
end

function ply:SkipNextKillRewards()
	self._skipNextKillRewards = true
end

function ply:IsAboutToSpawn()
	return !!self:GetProperty( "spawning" ) or !!self:GetProperty( "spawning_scp" )
end

function ply:IsValidSpectator()
	return !self:Alive() and self:IsActive() and !self:IsAFK() and self:SCPTeam() == TEAM_SPEC and !self:IsAboutToSpawn()
end

function ply:SCPCanInteract()
	return self:GetSCPCanInteract() or self:GetSCPHuman()
end