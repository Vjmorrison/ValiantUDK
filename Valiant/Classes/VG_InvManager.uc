class VG_InvManager extends UTInventoryManager;

/**
 * This function returns a sorted list of weapons, sorted by their InventoryWeight.
 *
 * @Returns the index of the current Weapon
 */
simulated function GetWeaponList(out array<UTWeapon> WeaponList, optional bool bFilter, optional int GroupFilter, optional bool bNoEmpty)
{
	local UTWeapon Weap;
	local int i;

	ForEach InventoryActors( class'UTWeapon', Weap )
	{
		if ( (!bFilter || Weap.InventoryGroup == GroupFilter) )
		{
			if ( WeaponList.Length>0 )
			{
				// Find it's place and put it there.

				for (i=0;i<WeaponList.Length;i++)
				{
					if (WeaponList[i].InventoryWeight > Weap.InventoryWeight)
					{
						WeaponList.Insert(i,1);
						WeaponList[i] = Weap;
						break;
					}
				}
				if (i==WeaponList.Length)
				{
					WeaponList.Length = WeaponList.Length+1;
					WeaponList[i] = Weap;
				}
			}
			else
			{
				WeaponList.Length = 1;
				WeaponList[0] = Weap;
			}
		}
	}
}

DefaultProperties
{
	
}
