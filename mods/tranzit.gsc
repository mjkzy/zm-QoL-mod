/*
        
    TranZit file.

*/

/*
setupTeleportersInit()
{
    if (ToLower(getDvar("mapname")) != "zm_transit") return;

    teleporters = GetStructArray("screecher_escape", "targetname");
    foreach(teleporter in teleporters)
        teleporter thread setupTeleporters();
}

setupTeleporters()
{
    for(;;)
    {
        foreach (player in level.players)
    	{
            if (distance(player.origin, self.origin) < 200)
            {
                self thread create_portal();
                wait 1;
                self notify("burrow_done");
                while(self.burrow_active)
                {
                    wait 1;
                }
                break;
            }
        }
        wait 1;
    }
}
*/