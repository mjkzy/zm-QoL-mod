/*

    Functions for spawning the player immediately on first connection are in this file.

*/


//this function monitors the first connection of the game for each player, to prevent abuse caused by repeatedly rejoining the game.
//self.first_connection should only be used for functions that are only supposed to happen once a game/map for a player, unlike the usual self.firstSpawn method, which would happen each time the player connects.
first_connection()
{

    guid = self getGuid();
    if(!isinarray(level.first_connection, guid))
    {
        arrayinsert(level.first_connection, guid, level.first_connection.size);
        self.first_connection = true;
    }
    else if(isinarray(level.first_connection, guid))
    {
        self.first_connection = false;
    }
}

//function to spawn a player if it is their first connection of the game.
spawn_on_join()
{
	level endon( "end_game" );
	self endon( "disconnect" );

	wait 5;
	if ( self.sessionstate == "spectator" && is_true(self.first_connection))
	{
		self [[ level.spawnplayer ]]();
		thread maps\mp\zombies\_zm::refresh_player_navcard_hud();
	}
    else if(!is_true(self.first_connection))
    {
        self iPrintLn("Please wait for the next round to respawn.");
    }
}