#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;

init()
{
    level thread onplayerconnect();
    level thread init_server_dvars();
    if ( getDvarIntDefault( "QOL_round_salary_on", 1 ) )
    {
        level thread round_salary();
    }
}

init_server_dvars()
{
    level.revive_actions = getDvarIntDefault("reviveActions", 1); // "set reviveActions 1";
}

onplayerconnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onplayerspawned();
    }
}

onplayerspawned()
{
    self endon("disconnect");
	level endon("end_game");
    self.firstSpawn = true;
    for(;;)
    {
        self waittill("spawned_player");

        // wait for the black screen to pass if the player is not joining later.
        if (!flag( "initial_blackscreen_passed" ) && !is_true(self.is_hotjoining)) {
            while(!flag( "initial_blackscreen_passed")) 
                wait 0.2;
        }

        if (self.firstSpawn) {
            // do stuff on first spawn. will prob need later.
            self.firstSpawn = false;
        }
    }
}