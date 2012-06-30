class VG_Rifle_SMG270 extends VG_Rifle;

DefaultProperties
{

	AmmoCount=30
	MaxAmmoCount=30

	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'WP_ShockRifle.Mesh.SK_WP_ShockRifle_1P'
		AnimSets(0)=AnimSet'WP_ShockRifle.Anim.K_WP_ShockRifle_1P_Base'
		Rotation=(Yaw=-16384)
		FOV=60.0
	End Object

	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'WP_ShockRifle.Mesh.SK_WP_ShockRifle_3P'
	End Object
	PivotTranslation=(Y=-25.0)

	BaseWeaponAimOffset(0) = 0.3;
	BaseWeaponAimOffset(1) = 0.3;

	Spread(0)=0.3

	bAutomatic = true;

	FireInterval(0)=+0.1

	InstantHitDamage(0)=5
	
	WeaponRange=22000
}
