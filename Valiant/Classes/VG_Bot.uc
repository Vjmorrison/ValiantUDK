class VG_Bot extends UTBot;


var() Vector TempDest;
var vector nextlocation;

/**
 * Scripting hook to move this AI to a specific actor.
 */
function OnAIMoveToActor(SeqAct_AIMoveToActor Action)
{
	local Actor DestActor;
	local SeqVar_Object ObjVar;

	// abort any previous latent moves
	ClearLatentAction(class'SeqAct_AIMoveToActor',true,Action);
	// pick a destination
	DestActor = Action.PickDestination(Pawn);
	// if we found a valid destination
	if (DestActor != None)
	{
		// set the target and push our movement state
		ScriptedRoute = Route(DestActor);
		if (ScriptedRoute != None)
		{
			if (ScriptedRoute.RouteList.length == 0)
			{
				`warn("Invalid route with empty MoveList for scripted move");
			}
			else
			{
				ScriptedRouteIndex = 0;
				if (!IsInState('ScriptedRouteMove'))
				{
					PushState('ScriptedRouteMove');
				}
			}
		}
		else
		{
			// MT->pop existing state if there is one
			if(IsInState('ScriptedMove'))
			{
				PopState(true);
			}
			ScriptedMoveTarget = DestActor;
			PushState('ScriptedMove');
// 			if (!IsInState('ScriptedMove'))
// 			{
// 				PushState('ScriptedMove');
// 			}
		}
		// set AI focus, if one was specified
		ScriptedFocus = None;
		foreach Action.LinkedVariables(class'SeqVar_Object', ObjVar, "Look At")
		{
			ScriptedFocus = Actor(ObjVar.GetObjectValue());
			if (ScriptedFocus != None)
			{
				break;
			}
		}
	}
	else
	{
		`warn("Invalid destination for scripted move");
	}
}

//Overwrite AIController's ScriptedMove state to make use of the NavigationHandle instead of the old way
state ScriptedMove
{
	function bool FindNavMeshPath()
	{
		// Clear cache and constraints (ignore recycling for the moment)
		NavigationHandle.PathConstraintList = none;
		NavigationHandle.PathGoalList = none;

		// Create constraints
		class'NavMeshPath_Toward'.static.TowardGoal( NavigationHandle,ScriptedMoveTarget );
		class'NavMeshGoal_At'.static.AtActor( NavigationHandle, ScriptedMoveTarget );

		// Find path
		return NavigationHandle.FindPath();
	}

	Begin:
		`log("BEGIN STATE SCRIPTEDMOVE");
		// while we have a valid pawn and move target, and
		// we haven't reached the target yet
		NavigationHandle.SetFinalDestination(ScriptedMoveTarget.Location);

		
		if( !NavigationHandle.ActorReachable( ScriptedMoveTarget) )
		{
			if( FindNavMeshPath() )
			{
				`log("FindNavMeshPath returned TRUE");
				FlushPersistentDebugLines();
				NavigationHandle.DrawPathCache(,TRUE);
			}
			else
			{
				//give up because the nav mesh failed to find a path
				`warn("FindNavMeshPath failed to find a path to"@ScriptedMoveTarget);
				ScriptedMoveTarget = None;
			}   
		}
		else
		{
			// then move directly to the actor
			MoveTo( ScriptedMoveTarget.Location,ScriptedFocus );
		}

		while( Pawn != None && ScriptedMoveTarget != None && !Pawn.ReachedDestination(ScriptedMoveTarget) )
		{				
			// move to the first node on the path
			if( NavigationHandle.GetNextMoveLocation( TempDest, Pawn.GetCollisionRadius()) )
			{
				// suggest move preparation will return TRUE when the edge's
			    // logic is getting the bot to the edge point
					// FALSE if we should run there ourselves
				if (!NavigationHandle.SuggestMovePreparation( TempDest,self))
				{
					MoveTo( TempDest, ScriptedFocus );						
				}
			}
		}

	`log("POPPING STATE!");
	Pawn.ZeroMovementVariables();
	// return to the previous state
	PopState();
}

DefaultProperties
{
}
