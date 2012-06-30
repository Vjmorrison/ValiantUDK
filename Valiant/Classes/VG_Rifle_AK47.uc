class VG_Rifle_AK47 extends VG_Rifle;

DefaultProperties
{
	bAutomatic = True;

	AmmoCount=20
	MaxAmmoCount=20

	FiringStatesArray(0)=WeaponFiring
	FiringStatesArray(1)=WeaponFiring

	WeaponFireTypes(0)=EWFT_InstantHit
	WeaponProjectiles(1)=None

	FireInterval(0)=+0.4
	FireInterval(1)=+1.0

	BaseWeaponAimOffset(0) = 0.3;
	BaseWeaponAimOffset(1) = 0.3;
	
	Spread(0)=0.3

	InstantHitDamage(0)=25
	InstantHitDamage(1)=0.0
	InstantHitMomentum(0)=0.0
	InstantHitMomentum(1)=0.0
	InstantHitDamageTypes(0)=class'DamageType'
	InstantHitDamageTypes(1)=class'DamageType'
	WeaponRange=22000
}
