#include maps/mp/zombies/_zm_laststand;
#include maps/mp/gametypes_zm/_spawnlogic;
#include maps/mp/gametypes_zm/_globallogic_defaults;
#include maps/mp/gametypes_zm/_hostmigration;
#include maps/mp/gametypes_zm/_spectating;
#include maps/mp/zombies/_zm_perks;
#include maps/mp/gametypes_zm/_globallogic_score;
#include maps/mp/gametypes_zm/_globallogic_ui;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/gametypes_zm/_hud_message;
#include maps/mp/gametypes_zm/_globallogic;
#include maps/mp/gametypes_zm/_globallogic_utils;
#include maps/mp/gametypes_zm/_globallogic_audio;
#include maps/mp/gametypes_zm/_spawning;
#include maps/mp/gametypes_zm/_globallogic_player;
#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes_zm/_tweakables;
#include maps/mp/_challenges;
#include maps/mp/gametypes_zm/_weapons;
#include maps/mp/_demo;
#include maps/mp/gametypes_zm/_globallogic_spawn;
#include maps/mp/zombies/_zm_stats;
#include maps/mp/zombies/_zm;

init()
{
    level thread onplayerconnect();
    level thread init_server_dvars();
    level thread init_scoreboard();
    level thread init_double_spawn();

    if (level.hitmarkers_on)
        level thread init_hitmarkers();

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
    if (level.zombie_counter_on)
        level thread drawZombiesCounter();
    level.disable_melee_lunge = getDvarIntDefault("QOL_disable_melee_lunge", 0);
    if (level.disable_melee_lunge)
        level thread disable_melee_lunge();
    level.disable_friendly_fire = getDvarIntDefault("QOL_disable_friendly_fire", 1);
    if (level.disable_friendly_fire)
        level thread disable_friendly_fire();
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

init_scoreboard()
{
    setdvar("g_ScoresColor_Spectator", ".25 .25 .25");
	setdvar("g_ScoresColor_Free", ".76 .78 .10");
	setdvar("g_teamColor_MyTeam", ".4 .7 .4");
	setdvar("g_teamColor_EnemyTeam", "1 .315 0.35");
	setdvar("g_teamColor_MyTeamAlt", ".35 1 1");
	setdvar("g_teamColor_EnemyTeamAlt", "1 .5 0");
	setdvar("g_teamColor_Squad", ".315 0.35 1");
	if (level.createfx_enabled)
		return;
	if (sessionmodeiszombiesgame()) {
		setdvar("g_TeamIcon_Axis", "faction_cia");
		setdvar("g_TeamIcon_Allies", "faction_cdc");
	} else {
		setdvar("g_TeamIcon_Axis", game["icons"]["axis"]);
		setdvar("g_TeamIcon_Allies", game["icons"]["allies"]);
	}
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

        if (self.firstSpawn) 
        {
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

