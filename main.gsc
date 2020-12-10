#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;

init()
{
    level thread onplayerconnect();
    // initalizing event, nothing happening here as of now.
}

onplayerconnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onplayerspawned();
        // connected player event, nothing happening here as of now.
    }
}

onplayerspawned()
{
    self endon("disconnect");
	level endon("game_ended");
    for(;;)
    {
        self waittill("spawned_player");
        // spawner player event, nothing happening here as of now.
    }
}
