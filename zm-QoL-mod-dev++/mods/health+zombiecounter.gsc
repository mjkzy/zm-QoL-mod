//Health and Zombie Counter + Welcome

welcome()
{
    self endon("disconnect");
    self waittill("spawned_player");
    wait 7;
	self iprintln("^5" +self.name + " ^7your perk limit has been removed");
}

drawZombiesCounter()
{
    level.zombiesCounter = createServerFontString("hudsmall" , 1.2);
    level.zombiesCounter setPoint("CENTER", "BOTTOM", "CENTER", 30);
    while(true)
    {
    	enemies = get_round_enemy_array().size + level.zombie_total;
        if( enemies != 0 )
        	level.zombiesCounter.label = &"^1Z^3o^2m^4b^6i^5e^0s: ^1";
        else
        	level.zombiesCounter.label = &"^1Z^3o^2m^4b^6i^5e^0s: ^8";
        level.zombiesCounter setValue( enemies );
        wait 0.05;
    }	
}

healthPlayer()
{
    self endon("disconnect");
    level endon("end_game");

    self.healthText = self createFontString("objective", 1.0);
    self.healthText setPoint("CENTER", "BOTTOM", "CENTER", 20);
    self.healthText.label = &"^0HEALTH: ^1";
    while (true)
    {
        self.healthText setValue(self.health);
        wait 0.05;
    }
}