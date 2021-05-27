/*

    Functions for spawning the player with perks on their first connection are in this file.

*/

give_player_perk_mix()
{
    players = level.players.size;
    switch (players) {
        case 1:
        case 2:
            self thread do_perk_mix_math(1);
            break;
        case 3:
        case 4:
            self thread do_perk_mix_math(2);
            break;
        case 5:
        case 6:
            self thread do_perk_mix_math(3);
            break;
        case 7:
        case 8:
            self thread do_perk_mix_math(4);
            break;
        case 9:
        case 10:
            self thread do_perk_mix_math(6);
            break;
        case 11:
        case 12:
            self thread do_perk_mix_math(7);
            break;
        case 13:
        case 14:
            self thread do_perk_mix_math(8);
            break;
        case 15:
        case 16:
            self thread do_perk_mix_math(10);
            break;
        case 17:
        case 18:
            self thread do_perk_mix_math(13);
            break;
        default:
            break;
    }
}

do_perk_mix_math(minPlayers)
{
    self.perksToGive = [];
    self.QOLjugg = 0;
    self.QOLrevive = 0;
    self.QOLreload = 0;
    self.QOLdoubletap = 0;
    self.QOLstaminup = 0;
    self.QOLdeadshot = 0;
    self.QOLflakjacket = 0;
    self.QOLmulekick = 0;
    self.QOLwhoswho = 0;

    // Step 1: Determine the number of perks each player has.
    foreach (player in level.players) {
        if (IsAlive(player)) {
            if (player HasPerk("specialty_armorvest")) { // jugg
                self.QOLjugg++;
            }
            if (player HasPerk("specialty_fastreload")) { // sleight of hand
                self.QOLreload++;
            }
            if (player HasPerk("specialty_quickrevive")) { // quick revive
                self.QOLrevive++;
            }
            if (player HasPerk("specialty_rof")) { // double tap
                self.QOLdoubletap++;
            }
            if (player HasPerk("specialty_longersprint")) {
                self.QOLstaminup++;
            }
            if (player HasPerk("specialty_deadshot")) {
                self.QOLdeadshot++;
            }
            if (player HasPerk("specialty_flakjacket")) {
                self.QOLflakjacket++;
            }
            if (player HasPerk("specialty_additionalprimaryweapon")) {
                self.QOLmulekick++;
            }
            if (player HasPerk("specialty_finalstand")) {
                self.QOLwhoswho++;
            }
        }
    }

    // Step 2: Count number of perks and if they are greater than or equal to the required amount, put
    // them in the "perks to give" array.

    if (self.QOLjugg >= minPlayers) ArrayInsert(self.perksToGive, "specialty_armorvest", self.perksToGive.size);
    if (self.QOLreload >= minPlayers) ArrayInsert(self.perksToGive, "specialty_fastreload", self.perksToGive.size);
    if (self.QOLrevive >= minPlayers) ArrayInsert(self.perksToGive, "specialty_quickrevive", self.perksToGive.size);
    if (self.QOLdoubletap >= minPlayers) ArrayInsert(self.perksToGive, "specialty_rof", self.perksToGive.size);
    if (self.QOLstaminup >= minPlayers) ArrayInsert(self.perksToGive, "specialty_longersprint", self.perksToGive.size);
    if (self.QOLdeadshot >= minPlayers) ArrayInsert(self.perksToGive, "specialty_deadshot", self.perksToGive.size);
    if (self.QOLflakjacket >= minPlayers) ArrayInsert(self.perksToGive, "specialty_flakjacket", self.perksToGive.size);
    if (self.QOLmulekick >= minPlayers) ArrayInsert(self.perksToGive, "specialty_additionalprimaryweapon", self.perksToGive.size);
    if (self.QOLwhoswho >= minPlayers) ArrayInsert(self.perksToGive, "specialty_finalstand", self.perksToGive.size);

    // Step 3: If the perk made it in the "perks to give" array, let's give those perks to the player.
    foreach (QOLperk in self.perksToGive) {
        self maps/mp/zombies/_zm_perks::give_perk(QOLperk);
    }

    if (level.player_perk_mix_printin) {
        self iprintln("You were given a mix of points from the alive players.");
    }
}

