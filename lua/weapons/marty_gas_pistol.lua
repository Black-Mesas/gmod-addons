SWEP.PrintName				= "Gas Pistol"

SWEP.Spawnable				= true
SWEP.UseHands				= true

SWEP.ViewModel				= "models/weapons/c_pistol.mdl"
SWEP.WorldModel				= "models/weapons/w_pistol.mdl"

SWEP.Author					= "Marty"
SWEP.Instructions			= "Left mouse to GAS..."
SWEP.Category				= "Marty's Weapons"

SWEP.Base					= "weapon_base"
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ShootSound = Sound( "ambient/fire/gascan_ignite1.wav" )

function SWEP:Reload()
	-- no reload
end

function SWEP:Think()
	-- no thinking
end

function SWEP:SecondaryAttack()
	-- no secondary attack
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + 0.1 )
	local owner = self:GetOwner()

	if ( not owner:IsValid() ) then return end

	self:EmitSound( self.ShootSound )
 
	if ( CLIENT ) then return end

	local ent = ents.Create( "prop_physics" )

	if ( not ent:IsValid() ) then return end

	ent:SetModel( "models/props_junk/propane_tank001a.mdl" )
	ent:SetOwner(self.Owner)

	local aimvec = owner:EyeAngles():Forward()
	local pos = aimvec * 48
	pos:Add( owner:EyePos() )

	ent:SetPos( pos )
	ent:SetAngles( owner:EyeAngles() + Angle(90) )
	ent:Spawn()
	ent:SetGravity(0)
	
	local phys = ent:GetPhysicsObject()
	if ( not phys:IsValid() ) then ent:Remove() return end
 
	aimvec:Mul( 50000 )
	aimvec:Add( VectorRand( -10, 10 ) )
	phys:ApplyForceCenter( aimvec )
 
	cleanup.Add( owner, "props", ent )
 
	undo.Create( "prop" )
		undo.AddEntity( ent )
		undo.SetPlayer( owner )
	undo.Finish("Gas Canister")
	owner:AddCleanup("prop", ent)
end
