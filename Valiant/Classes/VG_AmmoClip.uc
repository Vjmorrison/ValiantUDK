class VG_AmmoClip extends UTInventory
	abstract;

/** How many Clips you currently have */
var int CurrentClips;

/** The Maximum amount of clips you can carry*/
var int MaxClips;

/** the WeaponType that this clip goes to */
var class WeaponType;

/** The amount of rounds in a clip */
var int RoundsPerClip;

function bool AddClip()
{
	if(CurrentClips >= MaxClips)
	{
		return false;
	}
	else
	{
		CurrentClips++;
		return true;
	}
	
}

function bool DenyPickupQuery(class<Inventory> ItemClass, Actor Pickup)
{
	// By default, you can only carry a single item of a given class.
	if ( ItemClass == class )
	{
		AddClip();
		return true;
	}

	return false;
}

DefaultProperties
{
	CurrentClips = 1

	MaxClips = 10

	WeaponType = Class'VG_Weapon'

	RoundsPerClip = 10
}
