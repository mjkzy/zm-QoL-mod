/*
        
    Functions for rewarding the player reviving when they sucessfully revive another player. 
    Current rewards are points and speed boost.

*/

revive_rewards()
{
	self endon("disconnect");
    level endon("end_game");
    points = level.revive_rewards_points;
	for(;;) {
		self waittill("player_revived", reviver);
		if (self != reviver && isDefined(reviver)) {
            if(level.revive_rewards_points_on) {
                addPlayerPoints(reviver, points);
            }
            if(level.revive_rewards_speedboost_on) {
                reviver speed_reward();
            }
		}
        wait 0.02;
	}
}

//gives a player a doubled movement speed scale for a config defined length of time, with 5 seconds being the default.
speed_reward()
{
    length = level.revive_rewards_speedboost_length;
    self setMoveSpeedScale(1.2);
    wait length;
    self setMoveSpeedScale(1);
}

