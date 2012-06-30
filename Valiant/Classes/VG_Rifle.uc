class VG_Rifle extends VG_Weapon
	Abstract;




DefaultProperties
{
	bAutomatic = True;

	AmmoCount=30
	MaxAmmoCount=30

	FiringStatesArray(0)=WeaponFiring
	FiringStatesArray(1)=WeaponFiring

	WeaponFireTypes(0)=EWFT_InstantHit
	WeaponProjectiles(1)=None

	FireInterval(0)=+0.2
	FireInterval(1)=+1.0

	BaseWeaponAimOffset(0) = 0.1;
	BaseWeaponAimOffset(1) = 0.1;
	
	Spread(0)=0.1

	InstantHitDamage(0)=5
	InstantHitDamage(1)=0.0
	InstantHitMomentum(0)=0.0
	InstantHitMomentum(1)=0.0
	InstantHitDamageTypes(0)=class'DamageType'
	InstantHitDamageTypes(1)=class'DamageType'
	WeaponRange=22000
}
