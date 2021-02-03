/*
        
    TranZit file.

*/

setupTeleportersInit()
{
    teleporters = GetStructArray( "screecher_escape", "targetname" );
    foreach(teleporter in teleporters)
        teleporter thread setupTeleporters();
}

setupTeleporters()
{
    for(;;)
    {
        foreach (player in level.players)
    	{
            if(Distance(player.origin, self.origin) < 200)
            {
                self thread maps/mp/zm_transit_ai_screecher::create_portal();
                wait 1;
                self notify( "burrow_done" );
                while(is_true(self.burrow_active))
                {
                    wait 1;
                }
                break;
            }
        }
        wait 1;
    }
}
