#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;

init()
{
    level thread onplayerconnect();
    level thread init_server_dvars();
}

init_server_dvars()
{
    level.revive_actions = getDvarIntDefault("QOL_thank_reviver", 1);
    level.round_salary = getDvarIntDefault("QOL_round_salary_on", 1);
    level.round_salary_amount = getDvarIntDefault("QOL_round_salary_points_per_round", 50);
    level.revive_rewards_on = getDvarIntDefault("QOL_revive_rewards_on", 1);
    level.revive_rewards_points_on = getDvarIntDefault("QOL_revive_rewards_points_on", 1);
    level.revive_rewards_points = getDvarIntDefault("QOL_revive_rewards_points", 500);
    level.revive_rewards_speedboost_on = getDvarIntDefault("QOL_revive_rewards_speedboost_on", 1);
    level.revive_rewards_speedboost_length = getDvarIntDefault("QOL_revive_rewards_speedboost_length", 5);
    if (level.round_salary)
        level thread round_salary();
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
        if (!flag("initial_blackscreen_passed") && !is_true(self.is_hotjoining)) {
            flag_wait("initial_blackscreen_passed");
        }

        if (self.firstSpawn) {
            if (level.revive_rewards_on) {
                self thread revive_rewards();
            }
            self.firstSpawn = false;
        }
    }
}