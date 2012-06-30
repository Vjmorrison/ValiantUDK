class VG_Rocket extends VG_Weapon;

DefaultProperties
{
	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'WP_RocketLauncher.Mesh.SK_WP_RocketLauncher_1P'
		PhysicsAsset=None
		AnimTreeTemplate=AnimTree'WP_RocketLauncher.Anims.AT_WP_RocketLauncher_1P_Base'
		AnimSets(0)=AnimSet'WP_RocketLauncher.Anims.K_WP_RocketLauncher_1P_Base'
		Translation=(X=0,Y=0,Z=0)
		Rotation=(Yaw=0)
		scale=1.0
		FOV=60.0
		bUpdateSkelWhenNotRendered=true
	End Object

	AttachmentClass=class'UTGameContent.UTAttachment_RocketLauncher'

	// Pickup staticmesh
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'WP_RocketLauncher.Mesh.SK_WP_RocketLauncher_3P'
	End Object

	bAutomatic = false;

	AmmoCount=1
	MaxAmmoCount=1

	FiringStatesArray(0)=WeaponFiring
	FiringStatesArray(1)=WeaponFiring

	WeaponFireTypes(0)=EWFT_Projectile
	WeaponProjectiles(0)=class'UTProj_Rocket'
	WeaponProjectiles(1)=None

	FireInterval(0)=+0.35
	FireInterval(1)=+1.0

	BaseWeaponAimOffset(0) = 0.1;
	BaseWeaponAimOffset(1) = 0.1;
	
	Spread(0)=0.1


	InstantHitDamage(0)=10
	InstantHitDamage(1)=0.0
	InstantHitMomentum(0)=0.0
	InstantHitMomentum(1)=0.0
	InstantHitDamageTypes(0)=class'DamageType'
	InstantHitDamageTypes(1)=class'DamageType'
	WeaponRange=22000

	WeaponFireSnd[0]=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_Fire_Cue'
	WeaponFireSnd[1]=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_Fire_Cue'
	WeaponEquipSnd=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_Raise_Cue'
}
