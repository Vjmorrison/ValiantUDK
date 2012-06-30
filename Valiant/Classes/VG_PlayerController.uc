class VG_PlayerController extends UTPlayerController;

var int SprintSpeed, RunSpeed, WalkSpeed, SneakSpeed, CrawlSpeed;

var float SprintFOV, RunFOV, WalkFOV, SneakFOV, CrawlFOV;

var float SprintAim, RunAim, WalkAim, SneakAim, CrawlAim;

exec function SetHealth(int pHealth)
{
	pawn.Health = pHealth;
}

function UpdatePlayerSpeed()
{
	if(VG_Pawn(Pawn).bSprinting)
	{
		Pawn.GroundSpeed = SprintSpeed;
		self.DesiredFOV = SprintFOV;
		if(VG_Weapon(Pawn.Weapon) != none)
		{
			VG_Weapon(Pawn.Weapon).SetBaseAim(SprintAim);
		}
	}
	else if(VG_Pawn(Pawn).bRunning)
	{
		Pawn.GroundSpeed = RunSpeed;
		self.DesiredFOV = RunFOV;
		if(VG_Weapon(Pawn.Weapon) != none)
		{
			VG_Weapon(Pawn.Weapon).SetBaseAim(RunAim);
		}
	}
	else if(VG_Pawn(Pawn).bSneaking)
	{
		pawn.GroundSpeed = SneakSpeed;
		self.DesiredFOV = SneakFOV;
		if(VG_Weapon(Pawn.Weapon) != none)
		{
			VG_Weapon(Pawn.Weapon).SetBaseAim(SneakAim);
		}
	}
	else if(VG_Pawn(Pawn).bCrawling)
	{
		pawn.GroundSpeed = CrawlSpeed;
		self.DesiredFOV = CrawlFOV;
		if(VG_Weapon(Pawn.Weapon) != none)
		{
			VG_Weapon(Pawn.Weapon).SetBaseAim(CrawlAim);
		}
	}
	else
	{
		pawn.GroundSpeed = WalkSpeed;
		self.DesiredFOV = WalkFOV;
		if(VG_Weapon(Pawn.Weapon) != none)
		{
			VG_Weapon(Pawn.Weapon).SetBaseAim(WalkAim);
		}
	}
}

simulated exec function StartFire(optional byte FireModeNum)
{
	if(!VG_Pawn(Pawn).bSprinting)
	{
		Super.StartFire(FireModeNum);
	}
}


DefaultProperties
{
	SprintSpeed = 400
	RunSpeed= 250
	WalkSpeed=150
	SneakSpeed=75
	CrawlSpeed=50

	SprintFOV = 45
	RunFOV= 90
	WalkFOV=90
	SneakFOV=100
	CrawlFOV=112.5

	SprintAim = 1
	RunAim= 0.5
	WalkAim=0.1
	SneakAim=0.05
	CrawlAim=0.0

	DesiredFOV=67.5
	DefaultFOV=67.5
	FOVAngle=67.5
	CameraClass=None
	CheatClass=class'UTCheatManager'
	InputClass=class'Valiant.VG_PlayerInput'
	LastKickWarningTime=-1000.0
	bForceBehindview=true
	DamageCameraAnim=CameraAnim'FX_HitEffects.DamageViewShake'
	MatineeCameraClass=class'Engine.Camera'
	bCheckSoundOcclusion=true
	ZoomRotationModifier=0.5
	VehicleCheckRadiusScaling=1.0
	bRotateMiniMap=false

	PulseTimer=5.0;

	MinRespawnDelay=1.5
	IdentifiedTeam=255
	OldMessageTime=-100.0
	LastTeamChangeTime=-1000.0

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveform7
		Samples(0)=(LeftAmplitude=60,RightAmplitude=50,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.200)
	End Object
	CameraShakeShortWaveForm=ForceFeedbackWaveform7

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveform8
		Samples(0)=(LeftAmplitude=60,RightAmplitude=50,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.400)
	End Object
	CameraShakeLongWaveForm=ForceFeedbackWaveform8

	AchievementHandlerClass=Class'UTAchievements'
}
