/*
reward the player when they sucessfully revive another player

current rewards are points and speedboost.

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
            if(getDvarIntDefault( "QOL_revive_rewards_points_on", 1 ))
            {
                //adds the config defined amount of points to the reviver as a reward, with 500 points being the default.
		    	reviver maps/mp/zombies/_zm_score::player_add_points( "reviver", points );
            }

            if(getDvarIntDefault( "QOL_revive_rewards_speedboost_on", 1 ))
            {
                
                reviver speed_reward();
            }
                
		}
	}
}
//gives a player a doubled movement speed scale for a config defined length of time, with 5 seconds being the default.
speed_reward()
{
    length = getDvarIntDefault( "QOL_revive_rewards_speedboost_length", 5 );
    self setMoveSpeedScale(2);
    wait length;
    self setMoveSpeedScale(1);
}