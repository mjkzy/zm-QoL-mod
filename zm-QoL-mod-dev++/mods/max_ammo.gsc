/*

    BO4 Max Ammo
    Instead of modifying _zm_powerups, I can just use the wait event for doing it.

*/

monitorBO4ammo()
{
    self endon("disconnect");
    level endon("game_end");
    for(;;) {
        self waittill("zmb_max_ammo");
        weaps = self getweaponslist(1);
        foreach (weap in weaps) {
            self givemaxammo(weap);
            self setweaponammoclip(weap, weaponclipsize(weap));
        }
        wait 0.02;
    }
}
