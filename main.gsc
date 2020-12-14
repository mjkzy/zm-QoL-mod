#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm_laststand;

init()
{
    level thread onplayerconnect();
    level thread init_server_dvars();
    if (level.hitmarkers_on)
        level thread init_hitmarkers();
    if (level.zombie_counter_on)
        level thread drawZombiesCounter();
    level.first_connection = [];
}

init_server_dvars()
{
    level.spawn_on_join_on = getDvarIntDefault("QOL_spawn_on_join_on", 1);
    level.spawn_on_join_immunity_on = getDvarIntDefault("QOL_spawn_on_join_ignore_on", 1);
    level.spawn_on_join_immunity = getDvarIntDefault("QOL_spawn_on_join_ignore", 3);
    level.hitmarkers_on = getDvarIntDefault("QOL_hitmarkers_on", 1);
    level.hitmarkers_red = getDvarIntDefault("QOL_hitmarkers_red", 0);
    level.zombie_counter_on = getDvarIntDefault("QOL_zombie_counter_on", 0);
    level.disable_melee_lunge = getDvarIntDefault("QOL_disable_melee_lunge", 0);
    if (level.disable_melee_lunge)
        level thread disable_melee_lunge();
    level.give_player_semtex_on_spawn = getDvarIntDefault("QOL_give_semtex_on_spawn", 0);

    level.player_perk_mix = getDvarIntDefault("QOL_perks_on_join_on", 1);
    level.player_perk_mix_printin = getDvarIntDefault("QOL_perks_on_join_printin", 0);

    level.revive_actions = getDvarIntDefault("QOL_thank_reviver", 1);
    level.thank_reviver_expire_time = getDvarIntDefault("QOL_thank_reviver_expire_time", 5);
    level.thank_reviver_rewards_on = getDvarIntDefault("QOL_thank_reviver_rewards_on", 1);
    level.thank_reviver_get_points = getDvarIntDefault("QOL_thank_reviver_reward", 100);
    level.revive_rewards_on = getDvarIntDefault("QOL_revive_rewards_on", 1);
    level.revive_rewards_points_on = getDvarIntDefault("QOL_revive_rewards_points_on", 1);
    level.revive_rewards_points = getDvarIntDefault("QOL_revive_rewards_points", 500);
    level.revive_rewards_speedboost_on = getDvarIntDefault("QOL_revive_rewards_speedboost_on", 1);
    level.revive_rewards_speedboost_length = getDvarIntDefault("QOL_revive_rewards_speedboost_length", 3);

    level.round_salary = getDvarIntDefault("QOL_round_salary_on", 1);
    level.round_salary_amount = getDvarIntDefault("QOL_round_salary_points_per_round", 50);
    level.round_salary_printin = getDvarIntDefault("QOL_round_salary_printin", 0);
    if (level.round_salary)
        level thread round_salary();
}

onplayerconnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onplayerspawned();
        
        player first_connection();
        if(level.spawn_on_join_on)
            player thread spawn_on_join();
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

        if (level.give_player_semtex_on_spawn)
            self thread give_player_semtex();

        if (self.firstSpawn) {
            if (level.revive_rewards_on)
                self thread revive_rewards();
            if (level.revive_actions)
                self thread monitorLastStand();
            if (level.player_perk_mix) {
                if (self.first_connection)
                    self thread give_player_perk_mix();
            }
            self.firstSpawn = false;
        }
    }
}

// custom give player point function that plays with sound
addPlayerPoints(player, points)
{
    player playsound("zmb_cha_ching");
    player.score += points;
}

// disable melee lunging function
disable_melee_lunge()
{
	setDvar("aim_automelee_enabled", 0);
}

give_player_semtex()
{
	if (level.script != "zm_transit" && level.script != "zm_nuked" && level.script != "zm_highrise" && level.script != "zm_tomb") return;
	self takeweapon(self get_player_lethal_grenade());
	self set_player_lethal_grenade("sticky_grenade_zm");
	self giveweapon(self get_player_lethal_grenade());
	self setweaponammoclip(self get_player_lethal_grenade(), 0);
}