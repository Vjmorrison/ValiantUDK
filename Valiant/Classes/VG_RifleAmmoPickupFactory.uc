class VG_RifleAmmoPickupFactory extends VG_AmmoPickupFactory;

DefaultProperties
{
	Begin Object Name=ItemPickUpMesh
	    StaticMesh=StaticMesh'Pickups.Health_Large.Mesh.S_Pickups_Base_Health_Large'		
	End Object

	RespawnTime=30.000000
	MessageClass=class'UTPickupMessage'
	InventoryType=class'VG_RifleClips'
}
