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
#include maps/mp/gametypes_zm/_globallogic_spawn;
#include maps/mp/zombies/_zm_stats;
#include maps/mp/zombies/_zm;
#include maps/mp/zombies/_zm_utility;

#include maps/mp/zm_transit_ai_screecher;

init()
{
    level thread onplayerconnect();
    level thread init_server_dvars();
    level thread init_scoreboard();

    if (level.hitmarkers_on)
        level thread init_hitmarkers();

    level.first_connection = [];
}

init_server_dvars()
{
    level.perk_purchase_limit = getDvarIntDefault("QOL_perk_limit", 4);
    level.spawn_on_join_on = getDvarIntDefault("QOL_spawn_on_join_on", 0);
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
    level.bo4_max_ammo = getDvarIntDefault("QOL_bo4_max_ammo", 1);
    level.unlimited_sprint = getDvarIntDefault("QOL_unlimited_sprint", 0);

    // TranZit-specific mods
    if (ToLower(getDvar("mapname")) == "zm_transit") {
        if (maps/mp/zombies/_zm_weapons::is_weapon_included("jetgun_zm")) {
            level.jetgun_explode = getDvarIntDefault("QOL_jetgun_explode", 1);
            if (level.jetgun_explode)
                level.explode_overheated_jetgun = false;
            level.jetgun_unbuild = getDvarIntDefault("QOL_jetgun_unbuild", 1);
            if (level.jetgun_unbuild)
                level.unbuild_overheated_jetgun = false;
            level.jetgun_range = getDvarIntDefault("QOL_jetgun_range", 1000);
            if (level.jetgun_range != 1000)
                set_zombie_var("jetgun_grind_range", level.jetgun_range);
            level.screecher_on = getDvarIntDefault("QOL_denizens_ignore", 0);
            if (level.screecher_on)
                setDvar("scr_screecher_ignore_player", 1);
            level.spawn_teleports = getDvarIntDefault("QOL_spawn_teleporters", 0);
            if (level.spawn_teleports) {
                level thread setupTeleportersInit();
            }
        }
    }

    level.power_doors = getDvarIntDefault("QOL_power_doors_open", 1);
    if (level.power_doors)
        level.power_local_doors_globally = true;

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
    level.revive_rewards_speedboost_scale = getDvarIntDefault("QOL_revive_rewards_speedboost_scale", 1.2);

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
        if (level.spawn_on_join_on)
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

        if (level.unlimited_sprint)
            self setperk("specialty_unlimitedsprint");

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
            if (level.bo4_max_ammo)
                self thread monitorBO4ammo();
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
