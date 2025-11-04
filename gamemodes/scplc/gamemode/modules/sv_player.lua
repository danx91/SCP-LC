local PLAYER = FindMetaTable( "Player" )

--[[-------------------------------------------------------------------------
General Functions
---------------------------------------------------------------------------]]
function PLAYER:SetSCPClass( class )
	if !self.Set_SCPClass then
		self:DataTables()
	end

	self:Set_SCPClass( class )
	self:Set_SCPPersonaC( class )
end

function PLAYER:Cleanup( norem )
	hook.Run( "SLCPlayerCleanup", self )

	self:RemoveEffect()
	self:RemoveEFlags( EFL_NO_DAMAGE_FORCES )
	//self:AddEFlags( EFL_NO_DAMAGE_FORCES )

	self.SetupAsSpectator = nil //TODO move to properties
	self.DeathScreen = nil //TODO move to properties
	self.ClassData = nil
	self.SCPData = nil

	self:ResetProperties()
	self:ClearSpeedStack()
	self.PlayerData:Reset()
	self.Logger:Reset()

	self:SetExtraHealth( 0 )
	self:SetMaxExtraHealth( 0 )

	self:SetSanity( 100 )
	self:SetMaxSanity( 100 )

	controller.Stop( self )
	self:SetParent( NULL )
	self:SetMoveType( MOVETYPE_WALK )
	self:SetExhausted( false )
	self:SetStamina( 100 )
	self:SetMaxStamina( 100 )
	self:SetStaminaLimit( 100 )
	self:SetStaminaBoost( 0 )
	self:SetStaminaBoostDuration( 0 )

	self:ResetDisableControls()

	self:SetQueuePosition( 0 )

	self:SetRenderMode( RENDERMODE_NORMAL )
	self:SetColor( Color( 255, 255, 255, 255 ) )
	self:SetSubMaterial()
	self:SetMaterial( "" )

	self:SetSkin( 0 )
	for i = 1, self:GetNumBodyGroups() do
		self:SetBodygroup( i, 0 )
	end

	self:SetDSP( 0 )
	self:SetModelScale( 1 )
	self:Freeze( false )
	self:SetNoDraw( false )
	self:SetCustomCollisionCheck( false )
	self:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR )
	self:SetSolid( SOLID_BBOX )
	self:SetCanZoom( false )
	self:DrawShadow( false )
	self:StopBurn()
	self:GodDisable()

	self:StopAmbient()

	local holster = self:GetWeaponByBase( "item_slc_holster" )
	if IsValid( holster ) then
		self:SetActiveWeapon( holster )
	end

	if !norem then
		self:SetVest( 0 )
		self:RemoveAllAmmo()
		self:StripWeapons()
	end

	local sig = math.floor( CurTime() )
	self:SetTimeSignature( sig )

	net.Ping( "SLCPlayerSync", sig, self )

	net.Start( "PlayerCleanup" )
	net.WriteEntity( self )
	net.Broadcast()
end

function PLAYER:Despawn()
	for k, v in pairs( self:GetWeapons() ) do
		if v.DespawnDrop then
			self:PlayerDropWeapon( v:GetClass(), true, true )
		end
	end

	self:Cleanup()
	self:InvalidatePlayerForSpectate()
end

function PLAYER:DropEQ()
	self:DropVest( true )

	local wep = self:GetActiveWeapon()

	local holster = self:GetWeaponByBase( "item_slc_holster" )
	if IsValid( holster ) and holster != wep then
		self:SetActiveWeapon( holster )
	end

	if IsValid( wep ) then
		self:PlayerDropWeapon( wep:GetClass(), true, true )
	end
end

local function give_player_weapon( ply, class, ammo )
	local loadout = string.match( class, "^loadout:(.+)$" )
	if loadout then
		local l_wep, l_ammo = GetLoadoutWeapon( loadout, true )
		if !l_wep then return end
	
		class = l_wep
		ammo = ammo or l_ammo
	end

	local wep = ply:Give( class )
	if IsValid( wep ) then
		if !ammo then return wep end

		local clip_size = wep.Primary.ClipSize
		if clip_size == -1 then
			clip_size = 1
		end

		ammo = clip_size * ammo

		local clip = math.min( ammo, wep:GetMaxClip1() )
		if clip == -1 then
			clip = 1
		end

		local reserve = ammo - clip

		wep:SetClip1( clip )

		if reserve > 0 then
			ply:GiveAmmo( reserve, wep:GetPrimaryAmmoType() )
		end
	else
		print( "Failed to create weapon: "..class )
	end

	return wep
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

	self:Give( class.holster_override or "item_slc_holster" )
	self:Give( "item_slc_id" )

	if class.backpack then
		local bp_id = BACKPACK.GetID( class.backpack )
		if bp_id then
			local bp = self:Give( "item_slc_backpack" )
			if IsValid( bp ) then

				bp:SetBackpack( bp_id )
			end
		end
	end

	local chip = GetChip( istable( class.chip ) and table.Random( class.chip ) or class.chip )
	if class.omnitool then
		local omnitool = self:Give( "item_slc_omnitool" )
		if IsValid( omnitool ) and chip then
			omnitool:SetChipData( chip, GenerateAccessOverride( chip ) )
		end
	elseif chip then
		local wep = self:Give( "item_slc_access_chip" )
		if IsValid( wep ) then
			wep:SetChipData( chip )
		end
	end

	if class.loadout then
		give_player_weapon( self, "loadout:"..class.loadout )
	end

	for _, v in ipairs( class.weapons ) do
		if istable( v ) then
			local tab = table.Copy( v )

			for i = 1, v.amount or 1 do
				local wep_c = table.remove( tab, SLCRandom( #tab ) )
				give_player_weapon( self,  wep_c, class.ammo[wep_c] )
			end
		else
			give_player_weapon( self, v, class.ammo[v] )
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

	self:SetSkin( class.skin or 0 )

	for i = 1, self:GetNumBodyGroups() do
		self:SetBodygroup( i, 0 )
	end

	if class.bodygroups then
		for k, v in pairs( class.bodygroups ) do
			if isstring( k ) then
				k = self:FindBodygroupByName( k )
			end

			if k < 0 then continue end

			if v == "?" then
				v = SLCRandom( self:GetBodygroupCount( k ) )
			elseif isstring( v ) then
				local r1, r2 = string.match( v, "^(%d+):(%d+)$" )

				r1 = tonumber( r1 )
				r2 = tonumber( r2 )

				if r1 and r2 then
					v = SLCRandom( r1, r2 )
				else
					v = tonumber( v )
				end
			end

			if !isnumber( v ) then continue end

			self:SetBodygroup( k, v )
		end
	end

	self:SetupHands()

	if class.spawn_protection then
		self:ApplyEffect( "spawn_protection" )
	end

	self.ClassData = table.Copy( class )

	if class.vest then
		self:EquipVest( class.vest, true )
	end
	
	if class.callback then
		class.callback( self, class )
	end
	
	hook.Run( "SLCPlayerSetup", self )
end

function PLAYER:SetupPlayer( class, spawn, instant )
	if instant then
		setup_player_internal( self, class, spawn )
	else
		self:KillSilent()
		self:UnSpectate()
		self:SetPos( ZERO_POS )

		self:SetSCPClass( class.name )
		self:SetSCPTeam( class.team )

		self:SetProperty( "spawning", { class = class, spawn = spawn } )
		//info screen
		InfoScreen( self, "spawn", INFO_SCREEN_DURATION )

		self:AddTimer( "Spawn", INFO_SCREEN_DURATION, 1, function()
			setup_player_internal( self, class, spawn )
		end )
	end
end

function PLAYER:EquipVest( vest, silent, dur )
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
			self:SetVestDurability( dur or data.durability or -1 )
			
			local use_model
			local callback = VEST.GetCallback( vest )
			if callback then
				use_model = callback( self, vest, data )
			end

			local bodygroups = {}
			for i = 0, self:GetNumBodyGroups() - 1 do
				bodygroups[i] = self:GetBodygroup( i )
			end

			self:SetProperty( "vest_old_model", { self:GetModel(), self:GetSkin(), bodygroups } )
			self:SetModel( use_model or istable( data.model ) and table.Random( data.model ) or data.model )

			if data.skin then
				self:SetSkin( data.skin )
			end

			if data.bodygroups then
				for k, v in pairs( data.bodygroups ) do
					if isstring( k ) then
						k = self:FindBodygroupByName( k )
					end
		
					if k < 0 then continue end
		
					if v == "?" then
						v = SLCRandom( self:GetBodygroupCount( k ) )
					elseif isstring( v ) then
						local r1, r2 = string.match( v, "^(%d+):(%d+)$" )
		
						r1 = tonumber( r1 )
						r2 = tonumber( r2 )
		
						if r1 and r2 then
							v = SLCRandom( r1, r2 )
						else
							v = tonumber( v )
						end
					end
		
					if !isnumber( v ) then continue end
		
					self:SetBodygroup( k, v )
				end
			end

			self:PushSpeed( data.mobility, data.mobility, -1, "SLC_Vest" )

			if !silent then
				PlayerMessage( "vestpickup", self )
				self:EmitSound( "SLCPlayer.Vest" )
			end

			return true
		end
	end
end

function PLAYER:DropVest( silent )
	local vest = self:GetVest()
	if vest == 0 then return end

	local info = self:GetProperty( "vest_old_model" )
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
	local ent = VEST.Create( vest, pos )

	ent:SetDurability( self:GetVestDurability() )
	self:SetVestDurability( -1 )

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

	self:SetProperty( "vest_old_model" )
	self:PopSpeed( "SLC_Vest" )

	if !silent then
		PlayerMessage( "vestdrop", self )
		self:EmitSound( "SLCPlayer.Vest" )
	end

	hook.Run( "SLCArmorDropped", self )
end

function PLAYER:CreatePlayerRagdoll( disable_loot )
	if self:GetSCPNoRagdoll() then return end
	//if self:GetNoDraw() then return end

	local rag = ents.Create( "prop_ragdoll" )
	rag:SetPos( self:GetPos() )
	rag:SetAngles( self:GetAngles() )

	rag:SetModel( self:GetModel() )
	rag:SetColor( self:GetColor() )
	rag:SetMaterial( self:GetMaterial() )
	rag:SetSkin( self:GetSkin() )

	for i = 0, self:GetNumBodyGroups() - 1 do
		rag:SetBodygroup( i, self:GetBodygroup( i ) )
	end

	rag:SetOwner( self )

	for i = 0, #rag:GetMaterials() - 1 do
		local mat = self:GetSubMaterial( i )

		if mat != "" then
			rag:SetSubMaterial( i, mat )
		end
	end

	rag:Spawn()
	rag:Activate()

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

			physobj:SetVelocity( vel * 0.25 )
		end
	end

	local t = self:SCPTeam()

	rag:SetNWString( "nick", string.sub( self:Nick(), 1, 32 ) )
	rag:SetNWInt( "team", t )
	rag:SetNWFloat( "time", CurTime() )

	//rag:ResetSequence( "0_Death_64" )

	rag.Data = {
		time = CurTime(),
		team = t,
		class = self:SCPClass(),
		persona = { self:SCPPersona() },
	}

	if disable_loot != true and self:IsHuman() then
		/*local inv_bp = self:GetWeapon( "item_slc_backpack" )
		if IsValid( inv_bp ) then
			inv_bp:StoreBackpack()
		end*/

		local loot = {}

		for i, v in pairs( self:GetWeapons() ) do
			if !IsValid( v ) or v.Droppable == false or v.DespawnDrop or v.SCP then continue end

			local stored = self:StoreWeapon( v:GetClass(), true )

			table.insert( loot, {
				info = {
					class = stored.class,
					data = stored,
				},
				func = function( p, w_class, data )
					return nil, nil, p:RestoreWeapon( data )
				end
			} )
		end

		local wep = self:GetMainWeapon()
		if IsValid( wep ) then
			local ammo = math.floor( self:GetAmmoCount( wep:GetPrimaryAmmoType() ) * ( SLCRandom() * 0.2 + 0.1 ) )
			if ammo > 0 then
				table.insert( loot, {
					info = {
						class = "__slc_ammo",
						data  = { amount = ammo },
					},
					func = SLCLootFunctions.ammo
				} )
			end
		end

		local num = #loot
		local w, h = 3, 2
		
		if num > 12 then
			w, h = 5, math.ceil( num / w )
		elseif num > 10 then
			w, h = 4, 3
		elseif num > 8 then
			w, h = 5, 2
		elseif num > 6 then
			w, h = 4, 2
		end

		local function create_backpack( pos )
			local backpack = ents.Create( "slc_lootable" )
			if !IsValid( backpack ) then return end

			backpack.Model = "models/blacksnow/backpack.mdl"
			backpack.RemoveOnEmpty = true
			backpack:SetShouldRender( true )
			backpack:SetPos( pos )
			backpack:Spawn()

			return backpack
		end

		if disable_loot == "force_backpack" then
			local backpack = create_backpack( self:GetPos() + Vector( 0, 0, 5 ) )
			if backpack then
				backpack:SetLootData( w, h, loot )
			end
		else
			rag:InstallTable( "Lootable" )
			rag:SetLootData( w, h, loot )

			rag:CallOnRemove( "looting", function( ent )
				ent:DropAllListeners()

				local backpack = create_backpack( ent:GetPos() + Vector( 0, 0, 5 ) )
				if backpack then
					backpack:CopyLootData( ent )
				end
			end )

			rag.LootableCheck = 0
		end
	end

	if t != TEAM_SCP then
		self._RagEntity = rag
	end
	
	return rag
end

function PLAYER:Blink( delay, duration )
	if self:GetBlink() then return end

	local stop = false

	if !delay then
		delay = CVAR.slc_blink_delay:GetFloat()
		stop = true
	end

	if !duration then
		duration = 0.25
	end

	if delay < duration then
		delay = duration
	end

	self:SetBlink( true )
	self:SetNextBlink( stop and -1 or CurTime() + delay )

	net.Start( "PlayerBlink" )
		net.WriteFloat( duration )
		net.WriteFloat( delay )
	net.Send( self )

	self:AddTimer( "PlayerUnBlink", duration + 0.05, 1, function()
		if IsValid( self ) then
			self:SetBlink( false )
		end
	end )

	hook.Run( "SLCBlink", self, duration, delay )
end

--[[-------------------------------------------------------------------------
Premium
---------------------------------------------------------------------------]]
_OldSetUserGroup = _OldSetUserGroup or PLAYER.SetUserGroup
function PLAYER:SetUserGroup( ... )
	_OldSetUserGroup( self, ... )
	self:CheckPremium()
end

cvars.AddChangeCallback( CVAR.slc_premium_groups:GetName(), function( cvar, old, new )
	for i, v in ipairs( player.GetAll() ) do
		v:CheckPremium()
	end
end, "PremiumGroups" )

function PLAYER:CheckPremium()
	if !self.PlayerData then return end

	local groups = {}
	for s in string.gmatch( CVAR.slc_premium_groups:GetString(), "[^,]+" ) do
		table.insert( groups, string.Trim( s ) )
	end

	local premium = false
	for i, v in ipairs( groups ) do
		if self:IsUserGroup( v ) then
			premium = true
			break
		end
	end

	self:SetPremium( premium )
end

--[[-------------------------------------------------------------------------
SPEED SYSTEM
---------------------------------------------------------------------------]]
function PLAYER:PushSpeed( walk, run, crouch, id, maxstack, force_mult )
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

	if force_mult or walk > 0 and walk <= 2 then
		self:SetWalkSpeed( swalk * walk )
	elseif walk != -1 then
		self:SetWalkSpeed( walk )
	end

	if force_mult or run > 0 and run <= 2 then
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

function PLAYER:PopSpeed( id, all )
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

function PLAYER:SetBaseSpeed( walk, run, crouch )
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

function PLAYER:ClearSpeedStack()
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
function PLAYER:PlayerDropWeapon( class, all, force )
	local wep = self:GetWeapon( class )
	if !IsValid( wep ) then return end

	if wep.Droppable == false then return end
	if !force and ( wep.PreventDropping == true or wep.CanDrop and wep:CanDrop() == false or hook.Run( "SLCPlayerCanDropWeapon", self, class, all ) == false
		or wep.eq_slot and wep.eq_slot > 6 ) then return end

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

					new.PickupPriority = self
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

	if wep.SLCPreDrop then
		wep:SLCPreDrop( force, all )
	end

	self:DropWeapon( wep )

	wep.PickupPriority = self
	wep.Dropped = CurTime()

	self:UpdateEQ()
end

function PLAYER:StoreWeapon( class, norem )
	local wep = self:GetWeapon( class )

	if IsValid( wep ) then
		local data = {
			_stored = true,
			class = wep:GetClass(),
			clip1 = wep:Clip1(),
			clip2 = wep:Clip2(),
		}

		if wep.GetCustomClip then
			data.clip_custom = wep:GetCustomClip()
		end

		if wep.StoreWeapon then
			wep:StoreWeapon( data, self )
		end

		if !norem then
			wep:Remove()
		end

		return data
	end
end

function PLAYER:StoreWeapons()
	local data = {}

	for k, v in pairs( self:GetWeapons() ) do
		local class = v:GetClass()
		data[class] = self:StoreWeapon( class )
	end

	return data
end

function PLAYER:RestoreWeapon( data, wep )
	if !data._stored then return end

	local class = data.class

	if !IsValid( wep ) and self:GetFreeInventory() > 0 and hook.Run( "SLCCanPickupWeaponClass", self, class ) != false then
		wep = self:Give( class )
	end

	if IsValid( wep ) then
		wep:SetClip1( data.clip1 )
		wep:SetClip2( data.clip2 )

		if data.clip_custom and wep.SetCustomClip then
			wep:SetCustomClip( data.clip_custom )
		end

		if wep.RestoreWeapon then
			wep:RestoreWeapon( data, self )
		end

		return wep
	end
end

function PLAYER:RestoreWeapons( tab )
	for k, v in pairs( tab ) do
		self:RestoreWeapon( v )
	end
end

function PLAYER:ForceHolster()
	local holster = self:GetWeaponByBase( "item_slc_holster" )
	if IsValid( holster ) then
		self:SetActiveWeapon( holster )
	end
end

function PLAYER:SelectWeaponByBase( base )
	local wep = self:GetWeaponByBase( base )
	if IsValid( wep ) then
		self:SelectWeapon( wep:GetClass() )
	end
end

function PLAYER:UpdateEQ()
	local weps = self:GetWeapons()
	local lookup_weps = CreateLookupTable( weps )
	local backpack = self:GetWeapon( "item_slc_backpack" )
	local bp_size = IsValid( backpack ) and backpack:GetSize() or 0
	local inventory = self:GetProperty( "inventory", {} )

	//Remove weapon from cached inventory if they are missing from player inventory
	for k, v in pairs( inventory ) do
		if !IsValid( v ) or !lookup_weps[v] then
			//print( "REM WEP", k, v )
			inventory[k] = nil
		end
	end

	local lookup_tab = CreateLookupTable( inventory )

	//Add new weapons to cached inventory
	for i, v in ipairs( weps ) do
		local class = v:GetClass()
		if lookup_tab[v] or class == "item_slc_id" or v:IsDerived( "item_slc_holster" ) then continue end

		local target = 0

		//Find first empty slot in EQ
		for j = 1, 6 + bp_size do
			if !inventory[j] then
				target = j
				break
			end
		end

		//Add if empty slot is found
		if target > 0 then
			inventory[target] = v
			v.eq_slot = target
			//print( "ADD WEP EQ", target, v )
		else
			error( "Too many items! "..self:Nick().." "..#weps.."/"..6 + bp_size )
		end
	end
end

function PLAYER:MoveItem( from, to, from_class, to_class )
	if !self:Alive() or self:SCPTeam() == TEAM_SPEC then return end

	local ct = CurTime()
	local inventory = self:GetProperty( "inventory", {} )
	local transition = self:GetProperty( "inventory_transition", 0 )
	local max_eq = self:GetInventorySize()
	local backpack = from > 6 or to > 6

	if from > max_eq or to > max_eq then
		self:SyncEQ()
		error( "EQ out of sync (max slots)! "..self:Nick() )
	end

	local item_from = inventory[from]
	local item_to = inventory[to]

	//print( "EQ Move", self, item_from, from.." "..from_class, "<=>", item_to, to.." "..to_class, "BP?", backpack )

	if !IsValid( item_from ) then
		self:SyncEQ()
		error( "EQ out of sync (no item)! "..self:Nick() )
	end

	if from_class and from_class != ( IsValid( item_from ) and item_from:GetClass() or "" ) then
		self:SyncEQ()
		error( "EQ out of sync (F mismatch)! "..self:Nick() )
	end

	if to_class and to_class != ( IsValid( item_to ) and item_to:GetClass() or "" ) then
		self:SyncEQ()
		error( "EQ out of sync (T mismatch)! "..self:Nick() )
	end

	local wep = self:GetActiveWeapon()
	if backpack and ( item_from == wep or item_to == wep ) then
		self:SyncEQ()
		error( "Tried to backpack active item! "..self:Nick() )
	end

	if item_from and item_from.eq_trans and item_from.eq_trans > ct then
		print( "Invalid eq move! F", self, from, to )
		self:SyncEQ()
		return
	end

	if item_to and item_to.eq_trans and item_to.eq_trans > ct then
		print( "Invalid eq move! T", self, from, to )
		self:SyncEQ()
		return
	end

	inventory[to] = item_from
	inventory[from] = item_to

	if item_from then item_from.eq_slot = to end
	if item_to then item_to.eq_slot = from end

	if backpack then
		if transition < ct then
			transition = ct
		end

		transition = transition + CVAR.slc_time_swapping:GetFloat()
		self:SetProperty( "inventory_transition", transition )

		if item_from then item_from.eq_trans = transition end
		if item_to then item_to.eq_trans = transition end
	end
end

function PLAYER:SyncEQ()
	local inventory = self:GetProperty( "inventory", {} )
	local tab = {}

	print( "Syncing EQ", self )

	for k, v in pairs( inventory ) do
		if !IsValid( v ) then continue end
		tab[k] = v:GetClass()
	end

	net.Start( "SLCMoveItem" )
		net.WriteTable( tab )
	net.Send( self )
end

--[[-------------------------------------------------------------------------
Statis
---------------------------------------------------------------------------]]
--REVIEW: Is ammo stored by default?
function PLAYER:SetStasis( time )
	local data = {}

	//hook.Run( "SLCCreateStasisData", self, data )

	data.signature = self:TimeSignature()

	data.max_health = self:GetMaxHealth()
	data.health = self:Health()

	data.weapons = self:StoreWeapons()

	hook.Run( "SLCPlayerStasisStart", self, data )
	self:SetProperty( "stasis_data", data )

	self:CreatePlayerRagdoll( true )
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

function PLAYER:DisableStasis()
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
function PLAYER:MakeAFK( timeout )
	if self:IsAFK() then return end

	local rt = RealTime()
	self.SLCAFKTimer = rt + 10
	self:Set_SCPAFK( true )
	PlayerMessage( "afk", self )
	
	if timeout then
		self.SoftAFK = rt + timeout
	end
end

Timer( "SLCAFKCheck", 10, 0, function( self, n )
	local rt = RealTime()
	local afk_time = CVAR.slc_afk_time:GetInt()
	local afk_autoslay = CVAR.slc_afk_autoslay:GetInt()
	local afk_mode = CVAR.slc_afk_mode:GetInt()

	local players = player.GetAll()
	local server_full = #players == game.MaxPlayers()

	for k, v in pairs( players ) do
		if v:IsBot() then continue end

		if !v:IsAFK() then
			--print( "check", v, v.SLCAFKTimer, rt )
			if v:Alive() and afk_autoslay > 0 and v.SLCAFKTimer and v.SLCAFKTimer + afk_autoslay < rt then
				if v.AFKWarned then continue end

				v.AFKWarned = true
				net.Ping( "AFKSlayWarning", "", v )

				v:AddTimer( "SLCAFKSlay", 15, 1, function()
					//print( "fn", !v:Alive(), afk_autoslay <= 0, !v.SLCAFKTimer, v.SLCAFKTimer + afk_autoslay >= rt )
					if !v:Alive() or afk_autoslay <= 0 or !v.SLCAFKTimer or v.SLCAFKTimer + afk_autoslay >= rt then return end
					
					v:SkipNextKillRewards()
					v:Kill()
					v:MakeAFK()
				end )
			elseif afk_time > 0 and v.SLCAFKTimer and v.SLCAFKTimer + afk_time < rt then
				v:MakeAFK()
			end
		elseif !SLCAuth.HasAccess( v, "slc afkdontkick" ) then
			--print( "Player afk", v, math.floor( rt - v.SLCAFKTimer ) )

			if afk_mode == 1 and server_full then
				print( "AFK player kicked - Server is full" )
				v:Kick( "AFK" )
			elseif afk_mode >= 2 then
				if math.floor( rt - v.SLCAFKTimer ) >= afk_mode then
					print( "AFK player kicked - Maximum AFK time exceeded" )
					v:Kick( "AFK" )
				end
			end
		end
	end
end )

hook.Add( "SLCRound", "SLCAFK", function()
	local rt = RealTime()

	for i, v in ipairs( player.GetAll() ) do
		if v:IsAFK() then continue end

		v.SLCAFKTimer = rt
		v.AFKWarned = false
	end
end )

hook.Add( "PlayerSpawn", "SLCAFK", function( ply )
	ply.SLCAFKTimer = RealTime()
	ply.AFKWarned = false
end )

--[[-------------------------------------------------------------------------
Admin Mode
---------------------------------------------------------------------------]]
function PLAYER:ToggleAdminMode()
	if self:GetAdminMode() then
		self:SetAdminMode( false )

		self:SetActive( true )
		self:KillSilent()
		self:Cleanup()
		self:SetupSpectator()
	else
		self:SetAdminMode( true )

		self:SetActive( false )
		self:InvalidatePlayerForSpectate()
		self:SetSCPTeam( TEAM_SPEC )
		self:SetSCPClass( "spectator" )
		self:UnSpectate()
		self:Cleanup()
		self:Spawn()
		self:GodEnable()
		self:SetNoDraw( true )
		self:SetMoveType( MOVETYPE_NOCLIP )

		self:Give( "weapon_physgun" )
		self:Give( "tool_slc_remover" )
		self:Give( "tool_slc_inv" )
	end
end

--[[-------------------------------------------------------------------------
SLCTask
---------------------------------------------------------------------------]]
function PLAYER:IsDoingSLCTask( name )
	local task = self:GetProperty( "slc_task" )
	return task and ( !name or task.name == name ) or false
end

function PLAYER:StartSLCTask( name, time, check, show_bar, block_movement, args )
	local promise = SLCPromise( function( resolve, reject )
		if self:IsDoingSLCTask() then
			self:StopSLCTask( 2 )
		end

		local end_time = CurTime() + time

		self:SetProperty( "slc_task", {
			name = name,
			end_time = end_time,
			resolve = resolve,
			reject = reject,
			check = check,
			block_movement = block_movement,
			show_bar = show_bar,
			args = args,
		} )

		if show_bar then
			local bar_name, bar_c1, bar_c2

			if isstring( show_bar ) then
				bar_name = show_bar
			elseif istable( show_bar ) then
				bar_name = show_bar.name
				bar_c1 = show_bar.c1
				bar_c2 = show_bar.c2
			end

			self:EnableProgressBar( true, end_time, bar_name, bar_c1, bar_c2 )
		end

		if block_movement then
			self:DisableControls( "slc_task_"..name, isnumber( block_movement ) and block_movement or 0 )
		end
	end )

	return promise
end

function PLAYER:StopSLCTask( data )
	local task = self:GetProperty( "slc_task" )
	if task.show_bar then
		self:EnableProgressBar( false )
	end

	if task.block_movement then
		self:StopDisableControls( "slc_task_"..task.name )
	end

	if data then
		task.reject( data )
	end

	self:SetProperty( "slc_task", nil )
end

hook.Add( "Tick", "SLCTaskTick", function()
	local ct = CurTime()
	for i, v in ipairs( player.GetAll() ) do
		local task_data = v:GetProperty( "slc_task" )
		if task_data and task_data.end_time <= ct then
			task_data.resolve( task_data.args )
			v:StopSLCTask()
		elseif task_data and task_data.check then
			if !task_data.check() then
				v:StopSLCTask( 1 )
			end
		end
	end
end )

--[[-------------------------------------------------------------------------
Footsteps
---------------------------------------------------------------------------]]
local setp_off = Vector( 0, 0, 8 )
local step_trace = {}
step_trace.mins = Vector( -16, -16, -4 )
step_trace.maxs = Vector( 16, 16, 4 )
step_trace.mask = MASK_PLAYERSOLID
step_trace.output = step_trace

function PLAYER:PlayStepSound( no_update )
	if !self:Alive() then return end

	local mv = self:GetMoveType()
	if mv != MOVETYPE_WALK and mv != MOVETYPE_STEP and mv != MOVETYPE_LADDER then return end
	
	local foot = self.slc_foot == 0 and 1 or 0
	local snd = foot == 0 and "Default.StepLeft" or "Default.StepRight"
	
	self.slc_foot = foot
	
	if mv == MOVETYPE_LADDER then
		snd = foot == 0 and "Ladder.StepLeft" or "Ladder.StepRight"
	else
		local pos = self:GetPos()

		step_trace.start = pos
		step_trace.endpos = pos - setp_off
		step_trace.filter = self

		util.TraceLine( step_trace )

		if !step_trace.Hit then
			util.TraceHull( step_trace )
		end

		if !step_trace.Hit then return end

		local surf = util.GetSurfaceData( step_trace.SurfaceProps )
		if surf then
			snd = self.slc_foot == 0 and surf.stepLeftSound or surf.stepRightSound
		end
	end
	
	if self:Crouching() then
		snd = snd.."Crouch"
	elseif self:GetRunSpeed() == self:GetWalkSpeed() or !self:KeyDown( IN_SPEED ) then
		snd = snd.."Walk"
	end

	if hook.Run( "SLCPlayerFootstep", self, self.slc_foot, snd ) == true then return end

	self:EmitSound( snd )

	if !no_update then
		self:UpdateStepTime()
	end
end

function PLAYER:UpdateStepTime()
	local st = STEPTYPE_NORMAL

	if self:WaterLevel() > 0 then
		st = STEPTYPE_WATER
	elseif self:GetMoveType() == MOVETYPE_LADDER then
		st = STEPTYPE_LADDER
	end

	self.slc_next_footstep = hook.Run( "SLCFootstepParams", self, st, self:GetVelocity(), self:Crouching() )
end

--[[-------------------------------------------------------------------------
Progress Bar Binding
---------------------------------------------------------------------------]]
function PLAYER:EnableProgressBar( enable, endtime, text, col1, col2 )
	ProgressBar( self, enable, endtime, text, col1, col2 )
end

--[[-------------------------------------------------------------------------
Helper functions
---------------------------------------------------------------------------]]
Player_AddFrags = Player_AddFrags or PLAYER.AddFrags

function PLAYER:AddFrags( f )
	if hook.Run( "SLCAddFrags", self, f ) == true then return end

	if f > 0 then
		local team = self:SCPTeam()
		if team != TEAM_SPEC then
			SCPTeams.AddScore( team, f )
		end
	end

	Player_AddFrags( self, f )
end

function PLAYER:SetClassPoints( cp )
	self:Set_SCPClassPoints( cp )
	self:SetSCPData( "class_points", cp )
end

function PLAYER:AddClassPoints( cp )
	self:SetClassPoints( self:Get_SCPClassPoints() + cp )
end

function PLAYER:SetPrestigePoints( pp )
	self:Set_PrestigePoints( pp )
	self:SetSCPData( "prestige_points", pp )
end

function PLAYER:AddPrestigePoints( cp )
	self:SetPrestigePoints( self:GetPrestigePoints() + cp )
end

function PLAYER:SetSCPLevel( lvl )
	self:Set_SCPLevel( lvl )
	self:SetSCPData( "level", lvl )
end

function PLAYER:AddLevel( lvl )
	if lvl >= 0 then
		local level = self:Get_SCPLevel() + lvl

		self:SetSCPLevel( level )
		self:AddClassPoints( lvl )
	end

	hook.Run( "SLCPlayerLevel", self, lvl )
end

local xp_scale_mfn = function( tab, mul, cat )
	cat = cat or tab.main_category

	if !tab.categories[cat] then
		tab.categories[cat] = 0
	end

	tab.value = tab.value + mul
	tab.categories[cat] = tab.categories[cat] + mul
end

function PLAYER:AddXP( xp, category )
	if !isnumber( xp ) then return end
	category = category or "general"

	if !self._SLCXPCategories then
		self._SLCXPCategories = {}
	end

	//local lvlxp = CVAR.slc_xp_level:GetInt()
	//local lvlinc = CVAR.slc_xp_increase:GetInt()

	local plyxp = self:SCPExp()
	local level = self:SCPLevel()
	local orig_xp = plyxp

	local ref = setmetatable( {
		value = 1,
		main_category = category,
		categories = {
			[category] = 1,
		},
	}, { __call = xp_scale_mfn } )

	if self:IsPremium() then
		ref( CVAR.slc_premium_xp:GetFloat() - 1, "vip" )
	end

	hook.Run( "SLCScaleXP", self, ref )

	for k, v in pairs( ref.categories ) do
		self._SLCXPCategories[k] = ( self._SLCXPCategories[k] or 0 ) + math.floor( xp * v )
	end

	xp = math.floor( xp * ref.value )
	plyxp = plyxp + xp

	local daily_bonus = self:DailyBonus()
	if daily_bonus > 0 then
		local bonus = math.floor( xp * CVAR.slc_dailyxp_mul:GetFloat() )
		if bonus > daily_bonus then
			bonus = daily_bonus
		end

		plyxp = plyxp + bonus
		self._SLCXPCategories.daily = ( self._SLCXPCategories.daily or 0 ) + bonus

		daily_bonus = daily_bonus - bonus
		self:Set_DailyBonus( daily_bonus )
		self:SetSCPData( "daily_bonus", daily_bonus )
	end

	local sp_xp = CVAR.slc_spectator_points_xp:GetInt()
	if sp_xp > 0 then
		self:SetSpectatorPoints( self:GetSpectatorPoints() + math.floor( ( plyxp - orig_xp ) / sp_xp ) )
	end

	local req = self:RequiredXP( level ) //lvlxp + lvlinc * level
	local lvls = 0

	hook.Run( "SLCPlayerExperience", self, plyxp )

	while plyxp >= req do
		plyxp = plyxp - req
		lvls = lvls + 1
		req = self:RequiredXP( level + lvls ) //lvlxp + lvlinc * ( level + lvls )
	end

	self:AddLevel( lvls )

	self:Set_SCPExp( plyxp )
	self:SetSCPData( "xp", plyxp )

	return xp
end

function PLAYER:ExperienceSummary()
	local tmp = self._SLCXPCategories
	self._SLCXPCategories = {}

	return tmp or {}
end

function PLAYER:ResetDailyBonus( force )
	self:GetSCPData( "daily_bonus_reset", 0 ):Then( function( rs )
		if !IsValid( self ) then return end

		rs = tonumber( rs ) or 0
		if rs < SLC_UNIX_DAY or force then
			print( "Resetting daily XP bonus", self )

			self:SetSCPData( "daily_bonus_reset", SLC_UNIX_DAY )

			local amount = CVAR.slc_dailyxp_amount:GetInt()
			self:Set_DailyBonus( amount )
			self:SetSCPData( "daily_bonus", amount )
		end
	end )
end

function PLAYER:AddSanity( s )
	local sanity = self:GetSanity()
	local maxsanity = self:GetMaxSanity()

	self:SetSanity( math.Clamp( sanity + s, 0, maxsanity ) )
end

function PLAYER:AddHealth( num )
	local max = self:GetMaxHealth()
	local hp = self:Health() + num

	if hp > max then
		hp = max
	end

	self:SetHealth( hp )

	return hp
end

function PLAYER:SkipNextKillRewards()
	self._SkipNextKillRewards = true
end

function PLAYER:SkipNextRagdoll()
	self._SkipNextRagdoll = true
end

function PLAYER:SkipNextSuicide()
	self._SkipNextSuicide = true
end

function PLAYER:ForceSuicideQueue()
	self._ForceSuicideQueue = true
end

function PLAYER:IsAboutToSpawn()
	return !!self:GetProperty( "spawning" ) or !!self:GetProperty( "spawning_scp" )
end

function PLAYER:IsValidSpectator( ignore_death_screen, softafk )
	return !self:Alive() and self:IsActive() and self:SCPTeam() == TEAM_SPEC and !self:IsAboutToSpawn()
		and ( !self:IsAFK() or softafk and self.SoftAFK and self.SoftAFK >= RealTime() )
		and ( ignore_death_screen or !self.SetupAsSpectator and !self.DeathScreen )
end

function PLAYER:SCPCanInteract()
	return self:GetSCPCanInteract() or self:GetSCPHuman()
end