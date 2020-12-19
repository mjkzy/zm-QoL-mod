/*

    Functions for the zombie counter are in this file.

*/

drawZombiesCounter()
{
    level.zombiesCounter = createServerFontString("hudsmall" , 1.2);
    level.zombiesCounter setPoint("CENTER", "CENTER", "CENTER", 190);
    while(true)
    {
    	enemies = get_round_enemy_array().size + level.zombie_total;
        if ( enemies <= 3 )
        	level.zombiesCounter.label = &"Zombies: ^3";
        else if( enemies != 0 )
            level.zombiesCounter.label = &"Zombies: ^2";
        else
        	level.zombiesCounter.label = &"Zombies: ^1";
        level.zombiesCounter setValue( enemies );
        wait 0.05;
    }
}

