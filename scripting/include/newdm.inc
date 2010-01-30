/*
 * weapon restriction includes
 * 
 * This file has all static defines used in the weapon restriction module.
 */

#define TEAM_ALL    0
#define TEAM_T      2
#define TEAM_CT     3

#define TYPE_BUY        0
#define TYPE_RESTRICT   1
#define TYPE_REMOVE     2

enum WeaponType
{
    Weapon_Glock = 0, 	// 0
    Weapon_USP,		// 1
    Weapon_P228,	// 2
    Weapon_Deagle,	// 3
    Weapon_Elite,	// 4
    Weapon_FiveSeven,	// 5
    Weapon_M3,		// 6
    Weapon_XM1014,	// 7
    Weapon_Galil,	// 8
    Weapon_AK47,	// 9
    Weapon_Scout,	// 10
    Weapon_SG552,	// 11
    Weapon_AWP,		// 12
    Weapon_G3SG1,	// 13
    Weapon_Famas,	// 14
    Weapon_M4A1,	// 15
    Weapon_Aug,		// 16
    Weapon_SG550,	// 17
    Weapon_Mac10,	// 18
    Weapon_TMP,		// 19
    Weapon_MP5Navy,	// 20
    Weapon_Ump45,	// 21
    Weapon_P90,		// 22
    Weapon_M249,	// 23
    Weapon_FlashBang,
    Weapon_HEGrenade,
    Weapon_SmokeGrenade,
    Weapon_Knife,
    Weapon_C4,
    Weapon_Max
};

/*
 * Thanks to teame06 for
 * the below code.
 */ 
enum Slots
{
    Slot_Primary = 0,
    Slot_Secondary,
    Slot_Knife,
    Slot_Grenade,
    Slot_C4,
    Slot_None /* Not used for anything but a marker for last slot*/
};

new String:g_WeaponNames[][] = { "weapon_glock", "weapon_usp", "weapon_p228", "weapon_deagle",
                                 "weapon_elite", "weapon_fiveseven", "weapon_m3", "weapon_xm1014",
                                 "weapon_galil", "weapon_ak47", "weapon_scout", "weapon_sg552",
                                 "weapon_awp", "weapon_g3sg1", "weapon_famas", "weapon_m4a1",
                                 "weapon_aug", "weapon_sg550", "weapon_mac10", "weapon_tmp",
                                 "weapon_mp5navy", "weapon_ump45", "weapon_p90", "weapon_m249",
                                 "weapon_flashbang", "weapon_hegrenade", "weapon_smokegrenade",
                                 "weapon_knife", "weapon_c4"};

new String:g_ShortWeaponNames[][] = { "glock", "usp", "p228", "deagle",
                                 "elite", "fiveseven", "m3", "xm1014",
                                 "galil", "ak47", "scout", "sg552",
                                 "awp", "g3sg1", "famas", "m4a1",
                                 "aug", "sg550", "mac10", "tmp",
                                 "mp5navy", "ump45", "p90", "m249",
                                 "flashbang", "hegrenade", "smokegrenade",
				 "knife", "c4"};

new stock String:g_WeaponAmmo[][] = { "ammo_9mm", "ammo_45acp", "ammo_357sig", "ammo_50AE",
				"ammo_9mm", "ammo_57mm", "ammo_buckshot", "ammo_buckshot",
				"ammo_556mm", "ammo_762mm", "ammo_762mm", "ammo_556mm",
				"ammo_338mag", "ammo_762mm", "ammo_556mm", "ammo_556mm",
				"ammo_762mm", "ammo_556mm", "ammo_45acp", "ammo_9mm",
				"ammo_9mm", "ammo_45acp", "ammo_57mm", "ammo_556mm_box",
				"", "", "", "", ""};

new Slots:g_WeaponSlot[_:Weapon_Max] = { Slot_Secondary, Slot_Secondary, Slot_Secondary,
                                        Slot_Secondary, Slot_Secondary, Slot_Secondary,
                                        Slot_Primary, Slot_Primary, Slot_Primary,
                                        Slot_Primary, Slot_Primary, Slot_Primary,
                                        Slot_Primary, Slot_Primary, Slot_Primary,
                                        Slot_Primary, Slot_Primary, Slot_Primary,
                                        Slot_Primary, Slot_Primary, Slot_Primary,
                                        Slot_Primary, Slot_Primary, Slot_Primary,
                                        Slot_Grenade, Slot_Grenade, Slot_Grenade,
                                        Slot_Knife, Slot_C4};
/*
new g_WeaponPrices[_:Weapon_Max] = { 400, 500, 600, 650, 800, 750, 1700, 3000, 2000, 2500,
                                     2750, 3500, 4750, 5000, 2250, 3100, 3500, 4200, 1500,
                                     1250, 1500, 1700, 2350, 5750, 200, 300, 300, 0, 0 };
*/