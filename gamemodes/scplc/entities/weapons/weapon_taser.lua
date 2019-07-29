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
	SWEP.WepSelectIcon = Material( "slc/taser.png" )
	SWEP.SelectColor = Color( 255, 210, 0, 200 )
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

	fxdata = EffectData()
	fxdata:SetEntity( self )
	fxdata:SetAttachment( 1 )
	fxdata:SetStart( self.Owner:GetShootPos() )
	fxdata:SetOrigin( trace.HitPos )
	fxdata:SetNormal( trace.HitNormal )
	
	if CLIENT and IsFirstTimePredicted() then
		util.Effect( "effect_zeus_muzzleflash", fxdata )
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
			//dmginfo:SetDamageType(DMG_BULLET)
			dmginfo:SetDamageType( DMG_SHOCK )
			dmginfo:SetDamageForce( self:GetOwner():EyeAngles():Forward() * 1 )
			dmginfo:SetInflictor( self )
			
			if SERVER then ent:TakeDamageInfo( dmginfo ) end
		end
	else
			fxdata:SetOrigin( self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.Primary.Range )
			//print(fxdata:GetOrigin())
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
		shock:SetKeyValue( "m_flRadius", 20)
		shock:SetKeyValue( "m_SoundName", "DoSpark" )
		shock:SetKeyValue( "texture", "sprites/physcannon/bluelight1b.vmt" )
		shock:SetKeyValue( "thick_max", 5 )

		shock:Spawn()
		shock:Fire( "DoSpark", "", 0 )
		SafeRemoveEntityDelayed( shock, 1 )
		SafeRemoveEntityDelayed( target, 1 )

		//util.Effect("TeslaZap", fxdata)
	end
end















/*---------------
WORLDMODEL-FIXING UTILITY CODE
ORIGINALLY BY ROBOTBOY
----------------*/
    //SWEP.FixWorldModel = false
	SWEP.FixWorldModel = true
     
    SWEP.FixWorldModelPos = Vector( -3, 0, 0 )
     
    SWEP.FixWorldModelAng = Angle( 0, 0, 0 )
     
    SWEP.FixWorldModelScale = 1
     
function SWEP:DoFixWorldModel()
            if ( IsValid( self.Owner ) ) then
                    local att = self.Owner:GetAttachment( self.Owner:LookupAttachment( "anim_attachment_RH" ) )
                    if ( !att ) then return end
                    local pos, ang = att.Pos, att.Ang
                    ang:RotateAroundAxis( ang:Forward(), self.FixWorldModelAng.p )
                    ang:RotateAroundAxis( ang:Right(), self.FixWorldModelAng.y )
                    ang:RotateAroundAxis( ang:Up(), self.FixWorldModelAng.r )
                    pos = pos + ang:Forward() * self.FixWorldModelPos.x + ang:Right() * self.FixWorldModelPos.y + ang:Up() * self.FixWorldModelPos.z
                    self:SetModelScale( self.FixWorldModelScale, 0 )
                    self:SetRenderOrigin( pos )
                    self:SetRenderAngles( ang )
            else
                    self:SetRenderOrigin( self:GetNetworkOrigin() )
                    self:SetRenderAngles( self:GetNetworkAngles() )
            end 
end 

function SWEP:DrawWorldModel()
            if ( self.FixWorldModel ) then self:DoFixWorldModel() end
            self:DrawModel()
end