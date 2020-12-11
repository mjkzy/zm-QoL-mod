/*
        
    Reward the player when they sucessfully revive another player. Current rewards are points and speedboost.
    If enabled, revive_rewards() should be called for each player on connect/first spawn.

*/

revive_rewards()
{
	self endon("disconnect");
    level endon("end_game");
    points = level.revive_rewards_points;
	while (true) {
		self waittill("player_revived", reviver);
		if (isDefined(reviver)) {
            if(level.revive_rewards_points_on) {
		    	reviver.score += points;
            }
            if(level.revive_rewards_speedboost_on) {
                reviver speed_reward();
            }
		}
	}
}

//gives a player a doubled movement speed scale for a config defined length of time, with 5 seconds being the default.
speed_reward()
{
    length = level.revive_rewards_speedboost_length;
    self setMoveSpeedScale(2);
    wait length;
    self setMoveSpeedScale(1);
}