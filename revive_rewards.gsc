/*
reward the player when they sucessfully revive another player

current reward is points.

if enabled, revive_rewards() should be called for each player on connect/first spawn.

*/

revive_rewards()
{
	self endon( "disconnect" );
    level endon( "end_game");
    points = getDvarIntDefault( "QOL_revive_rewards_points", 500 );
	while ( true )
	{
		self waittill( "player_revived", reviver );

		if ( isDefined( reviver ) )
		{
            //adds the config defined amount of points to the reviver as a reward, with 500 points being the default.
			reviver maps/mp/zombies/_zm_score::player_add_points( "reviver", points );
		}
	}
}