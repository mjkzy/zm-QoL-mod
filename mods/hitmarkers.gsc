/*

    Functions for hitmarkers are in this file.

*/

init_hitmarkers()
{
    precacheshader( "damage_feedback" );
    level.redHm = getDvarIntDefault( "redHitmarkers", 1 );
    level.callbackactordamage = ::actor_damage_hitmarkers;
    level endon( "end_game" );
    while(true)
    {
		if (!flag("initial_blackscreen_passed"))
    		flag_wait( "initial_blackscreen_passed" );
		if(level.players > 0)
		{
        	foreach(player in level.players)
        	{
        		if(!isDefined( player.hud_damagefeedback))
        		{
        			player init_player_hitmarkers();
        		}
			}
        }
		wait 0.05;
    }
}

init_player_hitmarkers()
{
    self.hud_damagefeedback = newdamageindicatorhudelem(self);
    self.hud_damagefeedback.horzalign = "center";
    self.hud_damagefeedback.vertalign = "middle";
    self.hud_damagefeedback.x = -12;
    self.hud_damagefeedback.y = -12;
    self.hud_damagefeedback.alpha = 0;
    self.hud_damagefeedback.archived = 1;
    self.hud_damagefeedback.color = ( 1, 1, 1 );
    self.hud_damagefeedback setshader( "damage_feedback", 24, 48 );
    self.hitsoundtracker = 1;
    if (level.hitmarkers_red) {
        self.hud_damagefeedback_red = newdamageindicatorhudelem(self);
        self.hud_damagefeedback_red.horzalign = "center";
        self.hud_damagefeedback_red.vertalign = "middle";
        self.hud_damagefeedback_red.x = -12;
        self.hud_damagefeedback_red.y = -12;
        self.hud_damagefeedback_red.alpha = 0;
        self.hud_damagefeedback_red.archived = 1;
        self.hud_damagefeedback_red.color = ( 1, 0, 0 );
        self.hud_damagefeedback_red setshader( "damage_feedback", 24, 48 );
    }
}

actor_damage_hitmarkers(inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex)
{
	damage_override = self maps/mp/zombies/_zm::actor_damage_override( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex);	
	if ((self.health - damage_override) > 0)
	{
		self thread zombies_hitmarker_damage_callback( meansofdeath, attacker, damage_override, 0);
		self finishactordamage(inflictor, attacker, damage_override, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex);
	}
	else
	{
		self thread zombies_hitmarker_damage_callback(meansofdeath, attacker, damage_override, 1);
		self [[level.callbackactorkilled]](inflictor, attacker, damage_override, meansofdeath, weapon, vdir, shitloc, psoffsettime);
		self finishactordamage(inflictor, attacker, damage_override, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex);
	}
}

zombies_hitmarker_damage_callback(smeansofdeath, eattacker, idamage, death)
{
    if (isDefined(eattacker) && isplayer(eattacker) && eattacker != self)
    {
        if (dodamagefeedback(eattacker, idamage, smeansofdeath))
        {
            if (idamage > 0)
            {
                eattacker thread updatedamagefeedback(smeansofdeath, eattacker, death);
            }
        }
    }
}

dodamagefeedback(einflictor, idamage, smeansofdeath)
{
	if (level.allowhitmarkers == 0)
		return 0;
	return 1;
}

updatedamagefeedback(mod, inflictor, death)
{
	if (!isplayer(self) || isDefined(self.disable_hitmarkers))
	{
		return;
	}
	if (isDefined(mod) && mod != "MOD_CRUSH" && mod != "MOD_GRENADE_SPLASH" && mod != "MOD_HIT_BY_OBJECT")
	{
		if (isDefined(inflictor))
		{
			self playlocalsound("mpl_hit_alert");
		}
		if(death && level.hitmarkers_red)
		{
    		self.hud_damagefeedback_red setshader( "damage_feedback", 24, 48 );
			self.hud_damagefeedback_red.alpha = 1;
			self.hud_damagefeedback_red fadeovertime( 1 );
			self.hud_damagefeedback_red.alpha = 0;
		}
		else
		{
        	self.hud_damagefeedback setshader( "damage_feedback", 24, 48 );
			self.hud_damagefeedback.alpha = 1;
			self.hud_damagefeedback fadeovertime( 1 );
			self.hud_damagefeedback.alpha = 0;
		}
	}
    return 0;
}
