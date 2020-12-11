/*

    Concept for after you get revived, you can thank for the revive.

*/

monitorLastStand()
{
    self endon("disconnect");
    level endon("end_game");
    for(;;) {
        self waittill("player_revived", reviver);
        iprintln(reviver + " revived " + self.name)
        if (self != reviver && isDefined(reviver))
        {
            self.saidThanks = false;
            self thread monitorThanks(reviver);
            self thread renderThanksText();
        }
        wait 0.02;
    }
}

renderThanksText()
{
    self.thanksText = self createFontString("hudsmall", 1.3);
    self.thanksText setPoint("LEFT", "BOTTOM"); // not even sure if its right, but i need bottom left
    self.thanksText setText("^7Press ^3[{+actionslot 1}] ^7to say thanks.");
}

monitorThanks(reviver) // THIS WILL SOON BE REPLACED WITH NotifyOnPlayerCommand()
{
    self endon("disconnect");
    level endon("end_game");
    for(;;) {
        if (!self.saidThanks && !self player_is_in_laststand() && self ActionSlotOneButtonPressed()) {
            self.saidThanks = true;
            self.thanksText setText("");
            self.thanksText Destroy();
            self.thanksText Hide();
            self.thanksText Delete();
            reviver iprintln(self.name ": Thank you for the revive " + reviver.name + " !");
            self iprintln(self.name ": Thank you for the revive " + reviver.name + " !");
        }
        wait 0.02;
    }
}
