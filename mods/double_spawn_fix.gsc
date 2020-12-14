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
    level.spawnplayer = ::spawnplayer;
    level.spawnclient = ::spawnclient;
	level.allies = ::menuallieszombies;
	level.player_becomes_zombie = ::zombify_player;
}

spawnplayer() //checked matches cerberus output dvars taken from beta dump
{
	pixbeginevent( "spawnPlayer_preUTS" );
	self endon( "disconnect" );
	self endon( "joined_spectators" );
	self notify( "spawned" );
	level notify( "player_spawned" );
	self notify( "end_respawn" );
	self setspawnvariables();
	if ( !self.hasspawned )
	{
		self.underscorechance = 70;
		self thread maps/mp/gametypes_zm/_globallogic_audio::sndstartmusicsystem();
	}
	if ( level.teambased )
	{ 
		self.sessionteam = self.team;
	}
	else
	{
		self.sessionteam = "none";
		self.ffateam = self.team;
	}
	hadspawned = self.hasspawned;
	self.sessionstate = "playing";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.statusicon = "";
	self.damagedplayers = [];
	if ( getDvarInt( "scr_csmode" ) > 0 )
	{
		self.maxhealth = getDvarInt( "scr_csmode" );
	}
	else
	{
		self.maxhealth = level.playermaxhealth;
	}
	self.health = self.maxhealth;
	self.friendlydamage = undefined;
	self.hasspawned = 1;
	self.spawntime = getTime();
	self.afk = 0;
	if ( self.pers[ "lives" ] && !isDefined( level.takelivesondeath ) || level.takelivesondeath == 0 )
	{
		self.pers[ "lives" ]--;
		if ( self.pers[ "lives" ] == 0 )
		{
			level notify( "player_eliminated" );
			self notify( "player_eliminated" );
		}
	}
	self.laststand = undefined;
	self.revivingteammate = 0;
	self.burning = undefined;
	self.nextkillstreakfree = undefined;
	self.activeuavs = 0;
	self.activecounteruavs = 0;
	self.activesatellites = 0;
	self.deathmachinekills = 0;
	self.disabledweapon = 0;
	self resetusability();
	self maps/mp/gametypes_zm/_globallogic_player::resetattackerlist();
	self.diedonvehicle = undefined;
	if ( !self.wasaliveatmatchstart )
	{
		if ( level.ingraceperiod || maps/mp/gametypes_zm/_globallogic_utils::gettimepassed() < 20000 )
		{
			self.wasaliveatmatchstart = 1;
		}
	}
	self setdepthoffield( 0, 0, 512, 512, 4, 0 );
	self resetfov();
	pixbeginevent( "onSpawnPlayer" );
	if ( isDefined( level.onspawnplayerunified ) && getDvarInt( "scr_disableunifiedspawning" ) == 0 )
	{
		self [[ level.onspawnplayerunified ]]();
	}
	else
	{
		self [[ level.onspawnplayer ]]( 0 );
	}
	if ( isDefined( level.playerspawnedcb ) )
	{
		self [[ level.playerspawnedcb ]]();
	}
	pixendevent();
	pixendevent();
	level thread maps/mp/gametypes_zm/_globallogic::updateteamstatus();
	pixbeginevent( "spawnPlayer_postUTS" );
	self thread stoppoisoningandflareonspawn();
	self stopburning();
	self giveloadoutlevelspecific( self.team, self.class );
	if ( level.inprematchperiod )
	{
		self freeze_player_controls( 1 );
		team = self.pers[ "team" ];
		if ( isDefined( self.pers[ "music" ].spawn ) && self.pers[ "music" ].spawn == 0 )
		{
			if ( level.wagermatch )
			{
				music = "SPAWN_WAGER";
			}
			else
			{
				music = game[ "music" ][ "spawn_" + team ];
			}
			self thread maps/mp/gametypes_zm/_globallogic_audio::set_music_on_player( music, 0, 0 );
			self.pers[ "music" ].spawn = 1;
		}
		if ( level.splitscreen )
		{
			if ( isDefined( level.playedstartingmusic ) )
			{
				music = undefined;
			}
			else
			{
				level.playedstartingmusic = 1;
			}
		}
		if ( !isDefined( level.disableprematchmessages ) || level.disableprematchmessages == 0 )
		{
			thread maps/mp/gametypes_zm/_hud_message::showinitialfactionpopup( team );
			hintmessage = getobjectivehinttext( self.pers[ "team" ] );
			if ( isDefined( hintmessage ) )
			{
				self thread maps/mp/gametypes_zm/_hud_message::hintmessage( hintmessage );
			}
			if ( isDefined( game[ "dialog" ][ "gametype" ] ) && !level.splitscreen || self == level.players[ 0 ] )
			{
				if ( !isDefined( level.infinalfight ) || !level.infinalfight )
				{
					if ( level.hardcoremode )
					{
						self maps/mp/gametypes_zm/_globallogic_audio::leaderdialogonplayer( "gametype_hardcore" );
					}
					else
					{
						self maps/mp/gametypes_zm/_globallogic_audio::leaderdialogonplayer( "gametype" );
					}
				}
			}
			if ( team == game[ "attackers" ] )
			{
				self maps/mp/gametypes_zm/_globallogic_audio::leaderdialogonplayer( "offense_obj", "introboost" );
			}
			else
			{
				self maps/mp/gametypes_zm/_globallogic_audio::leaderdialogonplayer( "defense_obj", "introboost" );
			}
		}
	}
	else
	{
		self freeze_player_controls( 0 );
		self enableweapons();
		if ( !hadspawned && game[ "state" ] == "playing" )
		{
			pixbeginevent( "sound" );
			team = self.team;
			if ( isDefined( self.pers[ "music" ].spawn ) && self.pers[ "music" ].spawn == 0 )
			{
				self thread maps/mp/gametypes_zm/_globallogic_audio::set_music_on_player( "SPAWN_SHORT", 0, 0 );
				self.pers[ "music" ].spawn = 1;
			}
			if ( level.splitscreen )
			{
				if ( isDefined( level.playedstartingmusic ) )
				{
					music = undefined;
				}
				else
				{
					level.playedstartingmusic = 1;
				}
			}
			if ( !isDefined( level.disableprematchmessages ) || level.disableprematchmessages == 0 )
			{
				thread maps/mp/gametypes_zm/_hud_message::showinitialfactionpopup( team );
				hintmessage = getobjectivehinttext( self.pers[ "team" ] );
				if ( isDefined( hintmessage ) )
				{
					self thread maps/mp/gametypes_zm/_hud_message::hintmessage( hintmessage );
				}
				if ( isDefined( game[ "dialog" ][ "gametype" ] ) || !level.splitscreen && self == level.players[ 0 ] )
				{
					if ( !isDefined( level.infinalfight ) || !level.infinalfight )
					{
						if ( level.hardcoremode )
						{
							self maps/mp/gametypes_zm/_globallogic_audio::leaderdialogonplayer( "gametype_hardcore" );
						}
						else
						{
							self maps/mp/gametypes_zm/_globallogic_audio::leaderdialogonplayer( "gametype" );
						}
					}
				}
				if ( team == game[ "attackers" ] )
				{
					self maps/mp/gametypes_zm/_globallogic_audio::leaderdialogonplayer( "offense_obj", "introboost" );
				}
				else
				{
					self maps/mp/gametypes_zm/_globallogic_audio::leaderdialogonplayer( "defense_obj", "introboost" );
				}
			}
			pixendevent();
		}
	}
	if ( getDvar( "scr_showperksonspawn" ) == "" )
	{
		setdvar( "scr_showperksonspawn", "0" );
	}
	if ( level.hardcoremode )
	{
		setdvar( "scr_showperksonspawn", "0" );
	}
	if ( !level.splitscreen && getDvarInt( "scr_showperksonspawn" ) == 1 && game[ "state" ] != "postgame" )
	{
		pixbeginevent( "showperksonspawn" );
		if ( level.perksenabled == 1 )
		{
			self maps/mp/gametypes_zm/_hud_util::showperks();
		}
		self thread maps/mp/gametypes_zm/_globallogic_ui::hideloadoutaftertime( 3 );
		self thread maps/mp/gametypes_zm/_globallogic_ui::hideloadoutondeath();
		pixendevent();
	}
	if ( isDefined( self.pers[ "momentum" ] ) )
	{
		self.momentum = self.pers[ "momentum" ];
	}
	pixendevent();
	waittillframeend;
	self notify( "spawned_player" );
	logprint( "S;" + lpguid + ";" + lpselfnum + ";" + self.name + "\n" );
	setdvar( "scr_selecting_location", "" );
	self maps/mp/zombies/_zm_perks::perk_set_max_health_if_jugg( "health_reboot", 1, 0 );
	if ( game[ "state" ] == "postgame" )
	{
		self maps/mp/gametypes_zm/_globallogic_player::freezeplayerforroundend();
	}
}

spawnclient( timealreadypassed ) //checked matches cerberus output
{
	pixbeginevent( "spawnClient" );
	if ( !self mayspawn() )
	{
		currentorigin = self.origin;
		currentangles = self.angles;
		self showspawnmessage();
		self thread [[ level.spawnspectator ]]( currentorigin + vectorScale( ( 0, 0, 1 ), 60 ), currentangles );
		pixendevent();
		return;
	}
	if ( self.waitingtospawn )
	{
		pixendevent();
		return;
	}
	self.waitingtospawn = 1;
	self.allowqueuespawn = undefined;
	self waitandspawnclient( timealreadypassed );
	if ( isDefined( self ) )
	{
		self.waitingtospawn = 0;
	}
	pixendevent();
}

waitandspawnclient( timealreadypassed ) //this function is responsible for spawning the player in when they connect initially
{
	self endon( "disconnect" );
	self endon( "end_respawn" ); //commented this out as a temporary test to prevent it from being ended by another unknown function
	level endon( "game_ended" );
	if ( !isDefined( timealreadypassed ) )
	{
		timealreadypassed = 0;
	}
	spawnedasspectator = 0;
	if ( !isDefined( self.wavespawnindex ) && isDefined( level.waveplayerspawnindex[ self.team ] ) )
	{
		self.wavespawnindex = level.waveplayerspawnindex[ self.team ];
		level.waveplayerspawnindex[ self.team ]++;
	}
	timeuntilspawn = timeuntilspawn( 0 );
	if ( timeuntilspawn > timealreadypassed )
	{
		timeuntilspawn -= timealreadypassed;
		timealreadypassed = 0;
	}
	else
	{
		timealreadypassed -= timeuntilspawn;
		timeuntilspawn = 0;
	}
	if ( timeuntilspawn > 0 )
	{
		if ( level.playerqueuedrespawn )
		{
			setlowermessage( game[ "strings" ][ "you_will_spawn" ], timeuntilspawn );
		}
		else if ( self issplitscreen() )
		{
			setlowermessage( game[ "strings" ][ "waiting_to_spawn_ss" ], timeuntilspawn, 1 );
		}
		else
		{
			setlowermessage( game[ "strings" ][ "waiting_to_spawn" ], timeuntilspawn );
		}
		if ( !spawnedasspectator )
		{
			spawnorigin = self.origin + vectorScale( ( 0, 0, 1 ), 60 );
			spawnangles = self.angles;
			if ( isDefined( level.useintermissionpointsonwavespawn ) && [[ level.useintermissionpointsonwavespawn ]]() == 1 )
			{
				spawnpoint = maps/mp/gametypes_zm/_spawnlogic::getrandomintermissionpoint();
				if ( isDefined( spawnpoint ) )
				{
					spawnorigin = spawnpoint.origin;
					spawnangles = spawnpoint.angles;
				}
			}
			self thread respawn_asspectator( spawnorigin, spawnangles );
		}
		spawnedasspectator = 1;
		self maps/mp/gametypes_zm/_globallogic_utils::waitfortimeornotify( timeuntilspawn, "force_spawn" );
		self notify( "stop_wait_safe_spawn_button" );
	}
	wavebased = level.waverespawndelay > 0;
	if ( flag( "start_zombie_round_logic") )
	{
		setlowermessage( game[ "strings" ][ "press_to_spawn" ] );
		if ( !spawnedasspectator )
		{
			self thread respawn_asspectator( self.origin + vectorScale( ( 0, 0, 1 ), 60 ), self.angles );
		}
		spawnedasspectator = 1;
		self waitrespawnorsafespawnbutton();
	}
	self.waitingtospawn = 0;
	self clearlowermessage();
	self.wavespawnindex = undefined;
	self.respawntimerstarttime = undefined;
	self thread [[ level.spawnplayer ]]();
}

menuallieszombies() //checked changed to match cerberus output
{
	self maps/mp/gametypes_zm/_globallogic_ui::closemenus();
	if ( !level.console && level.allow_teamchange == "0" && is_true( self.hasdonecombat ) )
	{
		return;
	}
	if ( self.pers[ "team" ] != "allies" )
	{
		if ( level.ingraceperiod && !isDefined( self.hasdonecombat ) || !self.hasdonecombat )
		{
			self.hasspawned = 0;
		}
		if ( self.sessionstate == "playing" )
		{
			self.switching_teams = 1;
			self.joining_team = "allies";
			self.leaving_team = self.pers[ "team" ];
			self suicide();
		}
		self.pers["team"] = "allies";
		self.team = "allies";
		self.pers["class"] = undefined;
		self.class = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;
		self updateobjectivetext();
		if ( level.teambased )
		{
			self.sessionteam = "allies";
		}
		else
		{
			self.sessionteam = "none";
			self.ffateam = "allies";
		}
		self setclientscriptmainmenu( game[ "menu_class" ] );
		self notify( "joined_team" );
		level notify( "joined_team" );
		self notify( "end_respawn" );
	}
}

zombify_player() //checked matches cerberus output
{
	self maps/mp/zombies/_zm_score::player_died_penalty();
	bbprint( "zombie_playerdeaths", "round %d playername %s deathtype %s x %f y %f z %f", level.round_number, self.name, "died", self.origin );
	self recordplayerdeathzombies();
	if ( isDefined( level.deathcard_spawn_func ) )
	{
		self [[ level.deathcard_spawn_func ]]();
	}
	if ( !isDefined( level.zombie_vars[ "zombify_player" ] ) || !level.zombie_vars[ "zombify_player" ] )
	{
		self thread spawnspectator();
		return;
	}
	self.ignoreme = 1;
	self.is_zombie = 1;
	self.zombification_time = getTime();
	self.team = level.zombie_team;
	self notify( "zombified" );
	if ( isDefined( self.revivetrigger ) )
	{
		self.revivetrigger delete();
	}
	self.revivetrigger = undefined;
	self setmovespeedscale( 0.3 );
	self reviveplayer();
	self takeallweapons();
	self giveweapon( "zombie_melee", 0 );
	self switchtoweapon( "zombie_melee" );
	self disableweaponcycling();
	self disableoffhandweapons();
	setclientsysstate( "zombify", 1, self );
	self thread maps/mp/zombies/_zm_spawner::zombie_eye_glow();
	self thread playerzombie_player_damage();
	self thread playerzombie_soundboard();
}

spawnspectator() //checked matches cerberus output
{
	self endon( "disconnect" );
	self endon( "spawned_spectator" );
	self notify( "spawned" );
	self notify( "end_respawn" );
	if ( level.intermission )
	{
		return;
	}
	if ( is_true( level.no_spectator ) )
	{
		wait 3;
		exitlevel();
	}
	self.is_zombie = 1;
	level thread failsafe_revive_give_back_weapons( self );
	self notify( "zombified" );
	if ( isDefined( self.revivetrigger ) )
	{
		self.revivetrigger delete();
		self.revivetrigger = undefined;
	}
	self.zombification_time = getTime();
	resettimeout();
	self stopshellshock();
	self stoprumble( "damage_heavy" );
	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.maxhealth = self.health;
	self.shellshocked = 0;
	self.inwater = 0;
	self.friendlydamage = undefined;
	self.hasspawned = 1;
	self.spawntime = getTime();
	self.afk = 0;
	self detachall();
	if ( isDefined( level.custom_spectate_permissions ) )
	{
		self [[ level.custom_spectate_permissions ]]();
	}
	else
	{
		self setspectatepermissions( 1 );
	}
	self thread spectator_thread();
	self spawn( self.origin, self.angles );
	self notify( "spawned_spectator" );
}

waitrespawnorsafespawnbutton() //checked changed to match cerberus output
{
	self endon( "disconnect" );
	self endon( "end_respawn" );
	while ( 1 )
	{
		if ( self usebuttonpressed() )
		{
			return;
		}
		wait 0.05;
	}
}