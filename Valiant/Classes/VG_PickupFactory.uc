class VG_PickupFactory extends UTItemPickupFactory
	abstract;

/** This is the function where the action should go! */
function DoPickupAction(){};


function SpawnCopyFor( Pawn Recipient )
{
	DoPickupAction()

	if ( UTPlayerReplicationInfo(Recipient.PlayerReplicationInfo) != None )
	{
		UTPlayerReplicationInfo(Recipient.PlayerReplicationInfo).IncrementPickupStat(GetPickupStatName());
	}

	super.SpawnCopyFor(Recipient);
}

DefaultProperties
{
	Begin Object Class=StaticMeshComponent Name=ItemPickUpMesh
	    StaticMesh=StaticMesh'Pickups.Health_Large.Mesh.S_Pickups_Base_Health_Large'		
		CastShadow=FALSE
		bCastDynamicShadow=FALSE
		bAcceptsLights=TRUE
		bForceDirectLightMap=TRUE
		LightEnvironment=PickupLightEnvironment
		
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true

		CollideActors=false
		BlockActors=false
		BlockRigidBody=false

		MaxDrawDistance=4500
	End Object
	PickupMesh=ItemPickUpMesh
	Components.Add(ItemPickUpMesh)

	RespawnTime=30.000000
	MessageClass=class'UTPickupMessage'
	InventoryType=class'UTGame.UTPickupInventory'
}
