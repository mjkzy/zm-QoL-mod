/*

    Concept for after you get revived, you can thank for the revive.
    .

    Call every time player spawns:
    self thread checkSelfMonitors(true);

    Call for the first time the player spawns:
    self thread checkSelfMonitors(false);

*/

checkSelfMonitors(call_every_spawn)
{
    if (level.revive_actions && call_every_spawn) {
        self thread monitorLastStand();
    }
}

monitorLastStand()
{
    self endon("disconnect");
    self endon("bled_out");
    self endon("bleed_out");
    self endon("player_suicide");
    level endon("end_game");
    for(;;) {
        self waittill("player_downed");
        if (player_is_in_laststand()) {
            self waittill("player_revived");
            self.saidThanks = false;
            self thread monitorThanks();
            self thread renderThanksText();
        }
        wait 0.02;
    }
}

renderThanksText()
{
    self endon("SaidThanks");
    self.thanksText = self createFontString("hudsmall", 1.3);
    self.thanksText setPoint("LEFT", "BOTTOM"); // not even sure if its right, but i need bottom left
    while(!self.saidThanks) {
        self.thanksText setText("^7Press ^3[{+actionslot 1}] ^7to say thanks.");
    }
    if (self.saidThanks) {
        self.thanksText setText("");
        self.thanksText Destroy();
        self.thanksText Hide();
        self.thanksText Delete();
        self notify("SaidThanks");
    }
}

monitorThanks() // THIS WILL SOON BE REPLACED WITH NotifyOnPlayerCommand
{
    self endon("disconnect");
    level endon("end_game");
    for(;;) {
        if (!self.saidThanks && !self player_is_in_laststand() && self ActionSlotOneButtonPressed()) {
            self.saidThanks = true;
            foreach(kid in level.players) {
                kid IPrintLn("^7" + self.name + ": Thanks for the revive!");
            }
        }
        wait 0.02;
    }
}