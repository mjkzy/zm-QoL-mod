/*

    Functions for after revive actions are in this file.

*/

monitorLastStand()
{
    self endon("disconnect");
    level endon("end_game");
    for(;;) {
        self waittill("player_revived", reviver);
        if (self != reviver && isDefined(reviver)) {
            self.saidThanks = false;
            self thread afterReviveFunc(reviver);
        }
        wait 0.02;
    }
}

afterReviveFunc(reviver) {
    self thread renderThanksText(reviver);
    self thread monitorThanks(reviver);
    self thread deleteTextAfterXSeconds();
}

renderThanksText(reviver)
{
    self.thanksText = self createFontString("hudsmall", 1.2);
    self.thanksText setPoint("CENTER", "CENTER", -375, 160); // not even sure if its right, but i need bottom left
    self.thanksText setText("^7Press ^3[{+actionslot 1}] ^7to thank " + reviver.name);
}

monitorThanks(reviver)
{
    self endon("disconnect");
    self endon("stop_monitoring_revive_actions");
    level endon("end_game");
    for(;;) {
        if (!self.saidThanks && !self player_is_in_laststand() && self ActionSlotOneButtonPressed()) {
            self.saidThanks = true;
            self.thanksText setText("");
            self.thanksText Destroy();
            self.thanksText Hide();
            self.thanksText Delete();
            reviver iprintln(self.name + " thanks you for the revive!");
            self.reviveMessage = "You thanked " + reviver.name + ".";
            if (level.revive_rewards_on) {
                if (level.thank_reviver_rewards_on) {
                    //self.score += level.thank_reviver_get_points;
                    addPlayerPoints(self, level.thank_reviver_get_points);
                    self iprintln(self.reviveMessage + " (^7+^3100^7)");
                }
                else
                    self iprintln(self.reviveMessage);
            }
            else
                self iprintln(self.reviveMessage);
            self notify("stop_monitoring_revive_actions");
        }
        wait 0.02;
    }
}

deleteTextAfterXSeconds()
{
    self endon("disconnect");
    self endon("stop_monitoring_revive_actions");
    level endon("end_game");
    deletelength = level.thank_reviver_expire_time;
    for(;;) {
        if (!self.saidThanks && !self player_is_in_laststand()) {
            wait deletelength;
            if (!self.saidThanks) {
                self.thanksText setText("");
                self.thanksText Destroy();
                self.thanksText Hide();
                self.thanksText Delete();
                self notify("stop_monitoring_revive_actions");
            }
        }
    }
}
