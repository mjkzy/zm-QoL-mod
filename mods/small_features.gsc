/*

    Functions for the small features are in this file.

*/

// disable melee lunging function
disable_melee_lunge()
{
	setDvar("aim_automelee_enabled", 0);
}

// give player semtex on spawn
give_player_semtex()
{
	if (level.script != "zm_transit" && level.script != "zm_nuked" && level.script != "zm_highrise" && level.script != "zm_tomb") return;
	self takeweapon(self get_player_lethal_grenade());
	self set_player_lethal_grenade("sticky_grenade_zm");
	self giveweapon(self get_player_lethal_grenade());
	self setweaponammoclip(self get_player_lethal_grenade(), 0);
}

// disable the anti-friendly fire feature
disable_friendly_fire()
{
	setDvar( "g_friendlyfireDist", "0" );
}