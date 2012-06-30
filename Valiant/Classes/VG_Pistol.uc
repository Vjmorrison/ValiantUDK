class VG_Pistol extends VG_Weapon;

DefaultProperties
{
	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'WP_ShockRifle.Mesh.SK_WP_ShockRifle_1P'
		AnimSets(0)=AnimSet'WP_ShockRifle.Anim.K_WP_ShockRifle_1P_Base'
		Rotation=(Yaw=-16384)
		FOV=60.0
		Scale=0.1
	End Object

	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'WP_ShockRifle.Mesh.SK_WP_ShockRifle_3P'
		Scale=0.3
	End Object
	PivotTranslation=(Y=-25.0)

	AttachmentClass=class'Valiant.VG_WeaponAttachment'

	bAutomatic = false;

	AmmoCount=15
	MaxAmmoCount=15

	FiringStatesArray(0)=WeaponFiring
	FiringStatesArray(1)=WeaponFiring

	WeaponFireTypes(0)=EWFT_InstantHit
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
}
