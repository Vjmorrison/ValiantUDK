class VG_PlayerInput extends UTPlayerInput within VG_PlayerController;

var bool bSprint;
var float LastSprintTime;

simulated exec function LookForSprint()
{
	if ( VG_Pawn(Pawn)!= none )
	{
		if(!VG_Pawn(Pawn).bCrawling)
		{
			if (bSprint)
			{
				bSprint = false;
				ToggleSprint(False);
				return;
			}


			if ( WorldInfo.TimeSeconds - LastSprintTime < DoubleClickTime )
			{
				bSprint = true;
				ToggleSprint(True);
			}

			LastSprintTime = WorldInfo.TimeSeconds;
		}
	}
}

simulated exec function UnSprint()
{
	bSprint = false;
	ToggleSprint(False);
}

simulated exec function StartRun()
{
	if(!VG_Pawn(Pawn).bCrawling)
	{
		VG_Pawn(Pawn).bRunning = true;
		UnDuck();
		UpdatePlayerSpeed();
	}
}

simulated exec function StopRun()
{
	VG_Pawn(Pawn).bRunning = false;
	UpdatePlayerSpeed();
}

exec function ToggleSprint(bool bEnabled)
{
	if(!VG_Pawn(Pawn).bCrawling)
	{
		VG_Pawn(Pawn).bSprinting = bEnabled;
		UpdatePlayerSpeed();
	}
		
}

exec function ToggleSneak(bool bEnabled)
{
	if(!VG_Pawn(Pawn).bSprinting)
	{
		VG_Pawn(Pawn).bSneaking = bEnabled;
		UpdatePlayerSpeed();
		`Log("**************************************************************I am Sneaking!");
		`log("My GroundSpeed is: "@pawn.GroundSpeed);
	}
}

exec function ToggleCrawl(bool bEnabled)
{

	VG_Pawn(Pawn).bCrawling = bEnabled;
	if(bEnabled)
	{
		Pawn.CrouchHeight = 19.0;
		Pawn.SetPhysics(PHYS_Falling);
		Pawn.Mesh.AddImpulse(Pawn.Velocity*2);
	}
	else
	{
		Pawn.CrouchHeight = 29.0;
	}
	UpdatePlayerSpeed();
	`Log("**************************************************************I am Crawling!");
	`log("My GroundSpeed is: "@pawn.GroundSpeed);
	
}

simulated exec function Duck()
{
	if ( VG_Pawn(Pawn)!= none )
	{
		//If sprinting or running, DIVE!
		if(VG_Pawn(Pawn).bSprinting || VG_Pawn(Pawn).bRunning)
		{
			ToggleSprint(False);
			StopRun();
			ToggleCrawl(true);
			bHoldDuck = true;
			bDuck=1;
			return;
		}

		if (bHoldDuck)
		{
			bHoldDuck=false;
			bDuck=0;
			ToggleCrawl(false);
			return;
		}

		bDuck=1;
		ToggleSneak(True);

		if ( WorldInfo.TimeSeconds - LastDuckTime < DoubleClickTime )
		{
			bHoldDuck = true;
			ToggleSneak(False);
			ToggleCrawl(True);
		}

		LastDuckTime = WorldInfo.TimeSeconds;
	}
}

simulated exec function UnDuck()
{
	if (!bHoldDuck)
	{
		bDuck=0;
		ToggleSneak(False);
	}
}

exec function Jump()
{
	local UTPawn P;

	if (!IsMoveInputIgnored())
	{
		// jump cancels feign death
		P = UTPawn(Pawn);
		if (P != None && P.bFeigningDeath)
		{
			P.FeignDeath();
		}
		else
		{
		 	if (bDuck>0)
		 	{
		 		bDuck = 0;
		 		bHoldDuck = false;
		 	}
			Super.Jump();
		}
	}
}

DefaultProperties
{
}
