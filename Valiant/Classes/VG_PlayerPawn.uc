class VG_PlayerPawn extends VG_Pawn;

var float TimeSinceLastDamage;

var float RechargeTime;

var int HealthRechargeAmount;

event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local int OldHealth;

	// Attached Bio glob instigator always gets kill credit
	if (AttachedProj != None && !AttachedProj.bDeleteMe && AttachedProj.InstigatorController != None)
	{
		EventInstigator = AttachedProj.InstigatorController;
	}

	// reduce rocket jumping
	if (EventInstigator == Controller)
	{
		momentum *= 0.6;
	}

	// accumulate damage taken in a single tick
	if ( AccumulationTime != WorldInfo.TimeSeconds )
	{
		AccumulateDamage = 0;
		AccumulationTime = WorldInfo.TimeSeconds;
	}
    OldHealth = Health;
	AccumulateDamage += Damage;
	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	AccumulateDamage = AccumulateDamage + OldHealth - Health - Damage;

	TimeSinceLastDamage = WorldInfo.TimeSeconds;

}

function rechargeHealth()
{
	self.GiveHealth(HealthRechargeAmount, HealthMax);
}

function tick(float DeltaTime)
{
	super.Tick(DeltaTime);

	if(Worldinfo.TimeSeconds - TimeSinceLastDamage > RechargeTime)
	{
		rechargeHealth();
	}
	`log("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-Current Health:"@Health);
	
}

DefaultProperties
{
	Health = 100;
	HealthMax = 100;
	HealthRechargeAmount=1;
	RechargeTime = 3;
}
