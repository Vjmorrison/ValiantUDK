class VG_GameInfo extends UDKGame;

function bool ShouldRespawn( PickupFactory Other )
{
	return false;
}

DefaultProperties
{
	HUDType=class'Valiant.VG_HUD'
	PlayerControllerClass=class'Valiant.VG_PlayerController'
	DefaultPawnClass=class'VG_PlayerPawn'
	PlayerReplicationInfoClass=class'UTGame.UTPlayerReplicationInfo'
	GameReplicationInfoClass=class'UTGame.UTGameReplicationInfo'
	
	PopulationManagerClass=class'UTPopulationManager'

	bRestartLevel=true
	bDelayedStart=false
	bUseSeamlessTravel=true

	bPauseable=true

	// Voice is only transmitted when the player is actively pressing a key
	bRequiresPushToTalk=true

	MaxPlayersAllowed=1



}

	
