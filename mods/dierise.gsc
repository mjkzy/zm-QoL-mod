/*
        
    Die Rise file.

*/

slipgun_always_kill()
{
	level.slipgun_damage = maps/mp/zombies/_zm::ai_zombie_health( 255 );
}

slipgun_disable_reslip()
{
	level.zombie_vars["slipgun_reslip_rate"] = 0;
}