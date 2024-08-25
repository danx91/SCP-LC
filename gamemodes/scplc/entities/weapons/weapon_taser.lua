SWEP.Base = "item_slc_base"
SWEP.Language = "TASER"

SWEP.ViewModel = "models/weapons/c_csgo_taser.mdl"
SWEP.WorldModel = "models/weapons/csgo_world/w_eq_taser.mdl"
SWEP.UseHands = true

SWEP.ViewModelFOV = 45
SWEP.HoldType = "revolver"

SWEP.SwayScale = .25
SWEP.m_WeaponDeploySpeed = 1

SWEP.Primary.Damage = 200
SWEP.Primary.Delay = 1.337
SWEP.Primary.Range = 200
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1

SWEP.Primary.Sound = "csgo/taser/taser_shoot.wav"
SWEP.Primary.HitSound = "csgo/taser/taser_hit.wav"

if CLIENT then
	SWEP.WepSelectIcon = Material( "slc/items/taser.png" )
	SWEP.SelectColor = Color( 255, 210, 0, 255 )
end

//SWEP.FallbackMat = "models/weapons/csgo/taser"

function SWEP:Initialize()
	self:CallBaseClass( "Initialize" )
	self:SetMaterial( "models/weapons/csgo/taser" )
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:TakePrimaryAmmo( 1 )
	
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self:GetOwner():GetViewModel():SetPlaybackRate( 1 )
	self:EmitSound( self.Primary.Sound )

	self:GetOwner():LagCompensation( true )
	local trace = self:GetOwner():GetEyeTrace()

	local fxdata = EffectData()
	fxdata:SetEntity( self )
	fxdata:SetAttachment( 1 )
	fxdata:SetStart( self.Owner:GetShootPos() )
	fxdata:SetOrigin( trace.HitPos )
	fxdata:SetNormal( trace.HitNormal )
	
	if CLIENT and IsFirstTimePredicted() then
		util.Effect( "effect_zeus_muzzleflash", fxdata )
	elseif SERVER then
		timer.Simple( 1, function()
			if IsValid( self ) then
				self:Remove()
			end
		end )
	end

	if trace.Hit and self:GetPos():DistToSqr( trace.HitPos ) < 90000 then
		self:EmitSound( self.Primary.HitSound )
	
		self:MakeImpactEffect( fxdata )	
		if CLIENT and IsFirstTimePredicted() then
			util.Effect( "tooltracer", fxdata )
			util.Effect( "ManHackSparks", fxdata )
			util.Effect( "StunstickImpact", fxdata )
		end
		
		if trace.Entity then
			local ent = trace.Entity
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetDamage( self.Primary.Damage )
			dmginfo:SetDamageType( DMG_SHOCK )
			dmginfo:SetDamageForce( self:GetOwner():EyeAngles():Forward() * 1 )
			dmginfo:SetInflictor( self )
			
			if SERVER then ent:TakeDamageInfo( dmginfo ) end
		end
	else
		fxdata:SetOrigin( self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.Primary.Range )
		if CLIENT or game.SinglePlayer() and IsFirstTimePredicted() then
			util.Effect( "tooltracer", fxdata )
		end
	end


	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:GetOwner():LagCompensation( false )
end

function SWEP:MakeImpactEffect( fxdata )
	if SERVER then
		local shock = ents.Create( "point_tesla" )

		shock:SetPos( fxdata:GetOrigin() )
		shock:SetOwner( self:GetOwner() )
		shock:SetKeyValue( "beamcount_max", 15 )
		shock:SetKeyValue( "beamcount_min", 10 )
		shock:SetKeyValue( "interval_max", 0 )
		shock:SetKeyValue( "interval_min", 0 )
		shock:SetKeyValue( "lifetime_max", .25 )
		shock:SetKeyValue( "lifetime_min", .25 )
		shock:SetKeyValue( "m_Color", 200, 200, 255 )
		shock:SetKeyValue( "m_flRadius", 20 )
		shock:SetKeyValue( "m_SoundName", "DoSpark" )
		shock:SetKeyValue( "texture", "sprites/physcannon/bluelight1b.vmt" )
		shock:SetKeyValue( "thick_max", 5 )

		shock:Spawn()
		shock:Fire( "DoSpark", "", 0 )
		SafeRemoveEntityDelayed( shock, 1 )
	end
end

/*---------------
PIECE OF GARBAGE
ORIGINALLY BY ROBOTBOY

FIXED BY danx91
EDIT: NO, THIS IS NOT FIXED, IT STILL WORKS LIKE SHIT
----------------*/
SWEP.FixWorldModelPos = Vector( -3, 0, 0 )
SWEP.FixWorldModelAng = Angle( 0, 0, 0 )

function SWEP:DrawWorldModel()
     if IsValid( self.Owner ) then
        local att = self.Owner:GetAttachment( self.Owner:LookupAttachment( "anim_attachment_RH" ) )
        if att then
	        local ang = att.Ang
	        ang:RotateAroundAxis( ang:Forward(), self.FixWorldModelAng.p )
	        ang:RotateAroundAxis( ang:Right(), self.FixWorldModelAng.y )
	        ang:RotateAroundAxis( ang:Up(), self.FixWorldModelAng.r )

	        local pos = att.Pos
	        pos = pos + ang:Forward() * self.FixWorldModelPos.x + ang:Right() * self.FixWorldModelPos.y + ang:Up() * self.FixWorldModelPos.z

	        self:SetRenderOrigin( pos )
	        self:SetRenderAngles( ang )

	        self:DrawModel()
	        return
	    end
	end

	self:SetRenderOrigin( self:GetNetworkOrigin() )
   	self:SetRenderAngles( self:GetNetworkAngles() )
    //self:SetRenderOrigin( self:GetPos() )
    //self:SetRenderAngles( self:GetAngles() )

    

    self:DrawModel()
end

MarkAsWeapon( "weapon_taser" )