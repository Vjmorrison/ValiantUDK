class VG_Weapon extends UTWeapon
	abstract;

/** Determines if the Weapon is automatic or semi-Auto*/
var bool bAutomatic;

/** This is the Aim offset set by the current user Speed */
var float BaseAimOffset;

/** this is the Base offset of the weapon itself */
var array<float> BaseWeaponAimOffset;

function SetBaseAim(float pBaseAimOffset)
{
	BaseAimOffset = pBaseAimOffset;
	RefreshSpread();
}

function RefreshSpread()
{
	local int i;
	For(i=0; i < Spread.Length; i++)
	{
		Spread[i] = BaseWeaponAimOffset[i] + BaseAimOffset;
		`Log("_-=-=-=-=-=-=--=-=--=--==--=-=-=-=-=-==-"@Spread[i]);
	}
}

function SetAutomatic(bool bEnabled)
{
	bAutomatic = bEnabled;
}

simulated function bool ShouldRefire()
{
	`log("-=-=-=-=-=-=-=-=-=-=-=-=-Am I An Automatic? "@bAutomatic);

	// if doesn't have ammo to keep on firing, then stop
	if( !HasAmmo( CurrentFireMode ) )
	{
		return false;
	}

	// refire if owner is still willing to fire
	if(bAutomatic)
	{
		`log("-=-=-=-=-=-=-=-=-=-=-=-=- CHECKING TO SEE IF WE SHOULD BE FIRING");
		return StillFiring( CurrentFireMode );
	}
	else
	{
		`log("-=-=-=-=-=-=-=-=-=-=-=-=- I'm SEMIAUTO!");
		InvManager.ClearPendingFire(Self, CurrentFireMode);
		return False;
	}
}

/**
 * Called when the weapon runs out of ammo during firing
 */
simulated function WeaponEmpty()
{
	// If we were firing, stop
	if ( IsFiring() )
	{
		GotoState('Active');
	}

	/*
	if ( Instigator != none && Instigator.IsLocallyControlled() )
	{
		Instigator.InvManager.SwitchToBestWeapon( true );
	}
	*/
}

DefaultProperties
{
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

	AttachmentClass=class'Valiant.VG_WeaponAttachment'

	MessageClass=class'UTPickupMessage'
	DroppedPickupClass=class'UTDroppedPickup'

	ShotCost(0)=1
	ShotCost(1)=1

	AmmoCount=25
	MaxAmmoCount=100

	FiringStatesArray(0)=WeaponFiring
	FiringStatesArray(1)=WeaponFiring

	WeaponFireTypes(0)=EWFT_InstantHit
	WeaponFireTypes(1)=EWFT_Projectile
	WeaponProjectiles(1)=class'UTProj_ShockBall'

	FireInterval(0)=+1.0
	FireInterval(1)=+1.0

	BaseWeaponAimOffset(0) = 0.0;
	BaseWeaponAimOffset(1) = 0.0;

	Spread(0)=0.0
	Spread(1)=0.0

	InstantHitDamage(0)=45
	InstantHitDamage(1)=0.0
	InstantHitMomentum(0)=0.0
	InstantHitMomentum(1)=0.0
	InstantHitDamageTypes(0)=class'DamageType'
	InstantHitDamageTypes(1)=class'DamageType'
	WeaponRange=22000

	EffectSockets(0)=MuzzleFlashSocket
	EffectSockets(1)=MuzzleFlashSocket
	MuzzleFlashDuration=0.33

	WeaponFireSnd(0)=none
	WeaponFireSnd(1)=none

	MinReloadPct(0)=0.6
	MinReloadPct(1)=0.6

	MuzzleFlashSocket=MuzzleFlashSocket

	ShouldFireOnRelease(0)=0
	ShouldFireOnRelease(1)=0

	LockerRotation=(Pitch=16384)

	WeaponColor=(R=255,G=255,B=255,A=255)
	BobDamping=0.85000
	JumpDamping=1.0
	AimError=525
	CurrentRating=+0.5
	MaxDesireability=0.5

	WeaponFireAnim(0)=WeaponFire
	WeaponFireAnim(1)=WeaponFire
	ArmFireAnim(0)=WeaponFire
	ArmFireAnim(1)=WeaponFire

	WeaponPutDownAnim=WeaponPutDown
	ArmsPutDownAnim=WeaponPutDown
	WeaponEquipAnim=WeaponEquip
	ArmsEquipAnim=WeaponEquip
	WeaponIdleAnims(0)=WeaponIdle
	ArmIdleAnims(0)=WeaponIdle
	DefaultAnimSpeed=0.9

	IconX=458
	IconY=83
	IconWidth=31
	IconHeight=45

	EquipTime=+0.45
	PutDownTime=+0.33

	MaxPitchLag=600
	MaxYawLag=800
	RotChgSpeed=3.0
	ReturnChgSpeed=3.0
	AimingHelpRadius[0]=20.0
	AimingHelpRadius[1]=20.0

	CrosshairImage=none
	CrossHairCoordinates=(U=192,V=64,UL=64,VL=64)
	IconCoordinates=(U=600,V=341,UL=111,VL=58)
	CrosshairScaling=1.0

	LockedCrossHairCoordinates=(U=406,V=320,UL=76,VL=77)
	StartLockedScale=2.0
	FinalLockedScale=1.0
	LockedScaleTime=0.15
	CurrentLockedScale=1.0

 	ZoomInSound=SoundCue'A_Weapon_Sniper.Sniper.A_Weapon_Sniper_ZoomIn_Cue'
	ZoomOutSound=SoundCue'A_Weapon_Sniper.Sniper.A_Weapon_Sniper_ZoomOut_Cue'

	WeaponCanvasXPct=0.35
	WeaponCanvasYPct=0.35

	bExportMenuData=true
	LockerOffset=(X=0.0,Z=-15.0)

	bUsesOffhand=false

	WidescreenRotationOffset=(Pitch=900)
	HiddenWeaponsOffset=(Y=-50.0,Z=-50.0)
	ProjectileSpawnOffset=20.0
	LastHitEnemyTime=-1000.0

	SmallWeaponsOffset=(X=16.0,Y=6.0,Z=-6.0)
	WideScreenOffsetScaling=0.8
	SimpleCrossHairCoordinates=(U=276,V=84,UL=22,VL=25)

	/** controller rumble to play when firing. */
	Begin Object Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=30,RightAmplitude=20,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.100)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1
}
