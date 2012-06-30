class VG_Pawn extends UTPawn;

/** Speed Flags */
var bool bCrawling, bSneaking, bRunning, bSprinting;

/** Bob Cycle Speed */
var int HorizontalBobSpeed, VerticalBobSpeed;

//NO DODGING!
function bool Dodge(eDoubleClickDir DoubleClickMove);

simulated function SwitchWeapon(byte NewGroup)
{
	VG_PlayerController(Controller).UpdatePlayerSpeed();
	super.SwitchWeapon(NewGroup);
}

event UpdateEyeHeight( float DeltaTime )
{
	local float smooth, MaxEyeHeight, OldEyeHeight, Speed2D, OldBobTime;
	local Actor HitActor;
	local vector HitLocation,HitNormal, X, Y, Z;
	local int m,n;

	//Set Bob Values based on SPEED  (Derived from the good values of 100 Groundspeed = 4 horizonal and 400 groundspeed = 8 horizontal
	HorizontalBobSpeed = 4*Sqrt(GroundSpeed/100);
	VerticalBobSpeed = HorizontalBobSpeed*2;

	if ( !bJustLanded )
	{
		// normal walking around
		// smooth eye position changes while going up/down stairs
		smooth = FMin(0.9, 10.0 * DeltaTime/CustomTimeDilation);
		LandBob *= (1 - smooth);
		if( Physics == PHYS_Walking || Physics==PHYS_Spider || Controller.IsInState('PlayerSwimming') )
		{
			OldEyeHeight = EyeHeight;
			EyeHeight = FMax((EyeHeight - Location.Z + OldZ) * (1 - smooth) + BaseEyeHeight * smooth,
								-0.5 * CylinderComponent.CollisionHeight);
		}
		else
		{
			EyeHeight = EyeHeight * ( 1 - smooth) + BaseEyeHeight * smooth;
		}
	}
	else if ( bLandRecovery )
	{
		// return eyeheight back up to full height
		smooth = FMin(0.9, 9.0 * DeltaTime);
		OldEyeHeight = EyeHeight;
		LandBob *= (1 - smooth);
		// linear interpolation at end
		if ( Eyeheight > 0.9 * BaseEyeHeight )
		{
			Eyeheight = Eyeheight + 0.15*BaseEyeheight*Smooth;  // 0.15 = (1-0.75)*0.6
		}
		else
			EyeHeight = EyeHeight * (1 - 0.6*smooth) + BaseEyeHeight*0.6*smooth;
		if ( Eyeheight >= BaseEyeheight)
		{
			bJustLanded = false;
			bLandRecovery = false;
			Eyeheight = BaseEyeheight;
		}
	}
	else
	{
		// drop eyeheight a bit on landing
		smooth = FMin(0.65, 8.0 * DeltaTime);
		OldEyeHeight = EyeHeight;
		EyeHeight = EyeHeight * (1 - 1.5*smooth);
		LandBob += 0.08 * (OldEyeHeight - Eyeheight);
		if ( (Eyeheight < 0.25 * BaseEyeheight + 1) || (LandBob > 2.4)  )
		{
			bLandRecovery = true;
			Eyeheight = 0.25 * BaseEyeheight + 1;
		}
	}

	// don't bob if disabled, or just landed
	if( bJustLanded || !bUpdateEyeheight )
	{
		BobTime = 0;
		WalkBob = Vect(0,0,0);
	}
	else
	{
		// add some weapon bob based on jumping
		if ( Velocity.Z > 0 )
		{
		  JumpBob = FMax(-1.5, JumpBob - 0.03 * DeltaTime * FMin(Velocity.Z,300));
		}
		else
		{
		  JumpBob *= (1 -  FMin(1.0, 8.0 * DeltaTime));
		}

		// Add walk bob to movement ---------------------------------------------------------------------------WALK BOB!
		OldBobTime = BobTime;
		Bob = FClamp(Bob, -0.05, 0.05);

		if (Physics == PHYS_Walking )
		{
		  GetAxes(Rotation,X,Y,Z);
		  Speed2D = VSize(Velocity);
		  if ( Speed2D < 10 )
			  BobTime += 0.2 * DeltaTime;
		  else
			  BobTime += DeltaTime * (0.3 + 0.7 * Speed2D/GroundSpeed);
		  //LEFT TO RIGHT-----------------------------------------------------------------------------LEFT TO RIGHT BOB
		  WalkBob = Y * Bob * Speed2D * sin(HorizontalBobSpeed * BobTime);
		  AppliedBob = AppliedBob * (1 - FMin(1, 16 * deltatime));
		  WalkBob.Z = AppliedBob;
		  //UP AND DOWN BOB -------------------------------------------------------------------------- UP AND DOWN BOB
		  if ( Speed2D > 10 )
			  WalkBob.Z = WalkBob.Z + 0.75 * Bob * Speed2D * sin(VerticalBobSpeed * BobTime);
		}
		else if ( Physics == PHYS_Swimming )
		{
		  GetAxes(Rotation,X,Y,Z);
		  BobTime += DeltaTime;
		  Speed2D = Sqrt(Velocity.X * Velocity.X + Velocity.Y * Velocity.Y);
		  WalkBob = Y * Bob *  0.5 * Speed2D * sin(4.0 * BobTime);
		  WalkBob.Z = Bob * 1.5 * Speed2D * sin(8.0 * BobTime);
		}
		else
		{
		  BobTime = 0;
		  WalkBob = WalkBob * (1 - FMin(1, 8 * deltatime));
		}

		if ( (Physics == PHYS_Walking) && (VSizeSq(Velocity) > 100) && IsFirstPerson() )
		{
			m = int(0.5 * Pi + 9.0 * OldBobTime/Pi);
			n = int(0.5 * Pi + 9.0 * BobTime/Pi);

			if ( (m != n) && !bIsWalking && !bIsCrouched )
			{
			  ActuallyPlayFootStepSound(0);
			}
		}
		if ( !bWeaponBob )
		{
			WalkBob *= 0.1;
		}
	}
	if ( (CylinderComponent.CollisionHeight - Eyeheight < 12) && IsFirstPerson() )
	{
	  // desired eye position is above collision box
	  // check to make sure that viewpoint doesn't penetrate another actor
		// min clip distance 12
		if (bCollideWorld)
		{
			HitActor = trace(HitLocation,HitNormal, Location + WalkBob + (MaxStepHeight + CylinderComponent.CollisionHeight) * vect(0,0,1),
						  Location + WalkBob, true, vect(12,12,12),, TRACEFLAG_Blocking);
			MaxEyeHeight = (HitActor == None) ? CylinderComponent.CollisionHeight + MaxStepHeight : HitLocation.Z - Location.Z;
			Eyeheight = FMin(Eyeheight, MaxEyeHeight);
		}
	}
}

DefaultProperties
{

	HorizontalBobSpeed = 4
	VerticalBobSpeed = 8
/*
	CrawlHorizontalBobSpeed = 0
	CrawlVerticalBobSpeed = 0

	SneakHorizontalBobSpeed = 4
	SneakVerticalBobSpeed = 8

	WalkHorizontalBobSpeed = 5
	WalkVerticalBobSpeed = 10

	RunHorizontalBobSpeed = 6
	RunVerticalBobSpeed = 12

	SprintHorizontalBobSpeed = 8 
	SprintVerticalBobSpeed = 16

*/
	Begin Object Name=MyLightEnvironment
		bSynthesizeSHLight=TRUE
		bIsCharacterLightEnvironment=TRUE
		bUseBooleanEnvironmentShadowing=FALSE
		InvisibleUpdateTime=1
		MinTimeBetweenFullUpdates=.2
	End Object
	Components.Add(MyLightEnvironment)
	LightEnvironment=MyLightEnvironment

	Begin Object Name=WPawnSkeletalMeshComponent
		bCacheAnimSequenceNodes=FALSE
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		bOwnerNoSee=true
		CastShadow=true
		BlockRigidBody=TRUE
		bUpdateSkelWhenNotRendered=false
		bIgnoreControllersWhenNotRendered=TRUE
		bUpdateKinematicBonesFromAnimation=true
		bCastDynamicShadow=true
		Translation=(Z=8.0)
		RBChannel=RBCC_Untitled3
		RBCollideWithChannels=(Untitled3=true)
		LightEnvironment=MyLightEnvironment
		bOverrideAttachmentOwnerVisibility=true
		bAcceptsDynamicDecals=FALSE
		AnimTreeTemplate=AnimTree'ValiantAnims.BaseMale.BaseMale_Tree'
		bHasPhysicsAssetInstance=true
		TickGroup=TG_PreAsyncWork
		MinDistFactorForKinematicUpdate=0.2
		bChartDistanceFactor=true
		//bSkipAllUpdateWhenPhysicsAsleep=TRUE
		RBDominanceGroup=20
		Scale=1.075
		// Nice lighting for hair
		bUseOnePassLightingOnTranslucency=TRUE
		bPerBoneMotionBlur=true
	End Object
	Mesh=WPawnSkeletalMeshComponent
	Components.Add(WPawnSkeletalMeshComponent)

	DefaultMeshScale=1.075
	BaseTranslationOffset=6.0

	Begin Object Name=OverlayMeshComponent0
		Scale=1.015
		bAcceptsDynamicDecals=FALSE
		CastShadow=false
		bOwnerNoSee=true
		bUpdateSkelWhenNotRendered=false
		bOverrideAttachmentOwnerVisibility=true
		TickGroup=TG_PostAsyncWork
		bPerBoneMotionBlur=true
	End Object
	OverlayMesh=OverlayMeshComponent0

	Begin Object Name=MeshSequenceA
	End Object

	Begin Object Name=MeshSequenceB
	End Object

	Begin Object Name=FirstPersonArms
		PhysicsAsset=None
		FOV=55
		Animations=MeshSequenceA
		DepthPriorityGroup=SDPG_Foreground
		bUpdateSkelWhenNotRendered=false
		bIgnoreControllersWhenNotRendered=true
		bOnlyOwnerSee=true
		bOverrideAttachmentOwnerVisibility=true
		bAcceptsDynamicDecals=FALSE
		AbsoluteTranslation=false
		AbsoluteRotation=true
		AbsoluteScale=true
		bSyncActorLocationToRootRigidBody=false
		CastShadow=false
		TickGroup=TG_DuringASyncWork
	End Object
	ArmsMesh[0]=FirstPersonArms

	Begin Object Name=FirstPersonArms2
		PhysicsAsset=None
		FOV=55
		Scale3D=(Y=-1.0)
		Animations=MeshSequenceB
		DepthPriorityGroup=SDPG_Foreground
		bUpdateSkelWhenNotRendered=false
		bIgnoreControllersWhenNotRendered=true
		bOnlyOwnerSee=true
		bOverrideAttachmentOwnerVisibility=true
		HiddenGame=true
		bAcceptsDynamicDecals=FALSE
		AbsoluteTranslation=false
		AbsoluteRotation=true
		AbsoluteScale=true
		bSyncActorLocationToRootRigidBody=false
		CastShadow=false
		TickGroup=TG_DuringASyncWork
	End Object
	ArmsMesh[1]=FirstPersonArms2

	Begin Object Name=CollisionCylinder
		CollisionRadius=+0021.000000
		CollisionHeight=+0044.000000
	End Object
	CylinderComponent=CollisionCylinder

	Begin Object name=AmbientSoundComponent
	End Object
	PawnAmbientSound=AmbientSoundComponent
	Components.Add(AmbientSoundComponent)

	Begin Object name=AmbientSoundComponent2
	End Object
	WeaponAmbientSound=AmbientSoundComponent2
	Components.Add(AmbientSoundComponent2)

	ViewPitchMin=-18000
	ViewPitchMax=18000

	WalkingPct=+0.4
	CrouchedPct=+1
	BaseEyeHeight=38.0
	EyeHeight=38.0
	GroundSpeed=100.0
	AirSpeed=0
	WaterSpeed=50.0
	DodgeSpeed=600.0
	DodgeSpeedZ=295.0
	AccelRate=2048.0
	JumpZ=200.0
	CrouchHeight=29.0
	CrouchRadius=21.0
	WalkableFloorZ=0.78

	AlwaysRelevantDistanceSquared=+1960000.0
	InventoryManagerClass=class'VG_InvManager'

	MeleeRange=+20.0
	bMuffledHearing=true

	Buoyancy=+000.99000000
	UnderWaterTime=+00020.000000
	bCanStrafe=True
	bCanSwim=true
	RotationRate=(Pitch=20000,Yaw=20000,Roll=20000)
	MaxLeanRoll=2048
	AirControl=+0.35
	DefaultAirControl=+0.35
	bCanCrouch=true
	bCanClimbLadders=True
	bCanPickupInventory=True
	bCanDoubleJump=false
	MaxMultiJump = 0;
	SightRadius=+12000.0

	SoundGroupClass=class'UTGame.UTPawnSoundGroup'

	TransInEffects(0)=class'UTEmit_TransLocateOutRed'
	TransInEffects(1)=class'UTEmit_TransLocateOut'

	MaxStepHeight=26.0
	MaxJumpHeight=49.0

	HeadRadius=+9.0
	HeadHeight=5.0
	HeadScale=+1.0
	HeadOffset=32

	SpawnProtectionColor=(R=40,G=40)
	TranslocateColor[0]=(R=20)
	TranslocateColor[1]=(B=20)
	DamageParameterName=DamageOverlay
	SaturationParameterName=Char_DistSatRangeMultiplier

	TeamBeaconMaxDist=3000.f
	TeamBeaconPlayerInfoMaxDist=3000.f
	RagdollLifespan=18.0

	bPhysRigidBodyOutOfWorldCheck=TRUE
	bRunPhysicsWithNoController=true

	ControllerClass=class'Valiant.VG_Bot'

	CurrentCameraScale=1.0
	CameraScale=9.0
	CameraScaleMin=3.0
	CameraScaleMax=40.0

	LeftFootControlName=LeftFootControl
	RightFootControlName=RightFootControl
	bEnableFootPlacement=true
	MaxFootPlacementDistSquared=56250000.0 // 7500 squared

	SlopeBoostFriction=0.2
	bStopOnDoubleLanding=true
	FireRateMultiplier=1.0

	ArmorHitSound=SoundCue'A_Gameplay.Gameplay.A_Gameplay_ArmorHitCue'
	SpawnSound=none
	TeleportSound=none

	MaxFallSpeed=+1250.0
	AIMaxFallSpeedFactor=1.1 // so bots will accept a little falling damage for shorter routes
	LastPainSound=-1000.0

	FeignDeathBodyAtRestSpeed=12.0
	bReplicateRigidBodyLocation=true

	MinHoverboardInterval=0.7
	HoverboardClass=class'UTVehicle_Hoverboard'

	FeignDeathPhysicsBlendOutSpeed=2.0
	TakeHitPhysicsBlendOutSpeed=0.5

	TorsoBoneName=b_Spine2
	FallImpactSound=SoundCue'A_Character_BodyImpacts.BodyImpacts.A_Character_BodyImpact_BodyFall_Cue'
	FallSpeedThreshold=125.0

	SuperHealthMax=199

	// moving here for now until we can fix up the code to have it pass in the armor object
	ShieldBeltMaterialInstance=Material'Pickups.Armor_ShieldBelt.M_ShieldBelt_Overlay'
	ShieldBeltTeamMaterialInstances(0)=Material'Pickups.Armor_ShieldBelt.M_ShieldBelt_Red'
	ShieldBeltTeamMaterialInstances(1)=Material'Pickups.Armor_ShieldBelt.M_ShieldBelt_Blue'
	ShieldBeltTeamMaterialInstances(2)=Material'Pickups.Armor_ShieldBelt.M_ShieldBelt_Red'
	ShieldBeltTeamMaterialInstances(3)=Material'Pickups.Armor_ShieldBelt.M_ShieldBelt_Blue'

	HeroCameraPitch=6000
	HeroCameraScale=6.0

	//@TEXTURECHANGEFIXME - Needs actual UV's for the Player Icon
	IconCoords=(U=657,V=129,UL=68,VL=58)
	MapSize=1.0

	// default bone names
	WeaponSocket=WeaponPoint
	WeaponSocket2=DualWeaponPoint
	HeadBone=b_Head
	PawnEffectSockets[0]=L_JB
	PawnEffectSockets[1]=R_JB


	MinTimeBetweenEmotes=1.0

	DeathHipLinSpring=10000.0
	DeathHipLinDamp=500.0
	DeathHipAngSpring=10000.0
	DeathHipAngDamp=500.0

	bWeaponAttachmentVisible=true

	TransCameraAnim[0]=CameraAnim'Envy_Effects.Camera_Shakes.C_Res_IN_Red'
	TransCameraAnim[1]=CameraAnim'Envy_Effects.Camera_Shakes.C_Res_IN_Blue'
	TransCameraAnim[2]=CameraAnim'Envy_Effects.Camera_Shakes.C_Res_IN'

	MaxFootstepDistSq=9000000.0
	MaxJumpSoundDistSq=16000000.0

	SwimmingZOffset=-30.0
	SwimmingZOffsetSpeed=45.0

	TauntNames(0)=TauntA
	TauntNames(1)=TauntB
	TauntNames(2)=TauntC
	TauntNames(3)=TauntD
	TauntNames(4)=TauntE
	TauntNames(5)=TauntF

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformFall
		Samples(0)=(LeftAmplitude=50,RightAmplitude=40,LeftFunction=WF_Sin90to180,RightFunction=WF_Sin90to180,Duration=0.200)
	End Object
	FallingDamageWaveForm=ForceFeedbackWaveformFall

	CamOffset=(X=4.0,Y=28.0,Z=-13.0)
}
