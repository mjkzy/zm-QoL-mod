/*

    Functions for spawning the player with perks on their first connection are in this file.

*/

give_player_perk_mix()
{
    switch (level.players.size) {
        case 0:
            return;
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
    perksToGive = [];

    QOLjugg = 0;
    QOLrevive = 0;
    QOLreload = 0;
    QOLdoubletap = 0;
    QOLstaminup = 0;
    QOLdeadshot = 0;
    QOLflakjacket = 0;
    QOLmulekick = 0;
    QOLwhoswho = 0;

    // Step 1: Determine the number of perks each player has.
    foreach (player in level.players) {
        if (isAlive(player)) {
            if (player hasPerk("specialty_armorvest")) QOLjugg++;
            if (player hasPerk("specialty_fastreload")) QOLreload++;
            if (player hasPerk("specialty_quickrevive")) QOLrevive++;
            if (player hasPerk("specialty_rof")) QOLdoubletap++;
            if (player hasPerk("specialty_longersprint")) QOLstaminup++;
            if (player hasPerk("specialty_deadshot")) QOLdeadshot++;
            if (player hasPerk("specialty_flakjacket")) QOLflakjacket++;
            if (player hasPerk("specialty_additionalprimaryweapon")) QOLmulekick++;
            if (player hasPerk("specialty_finalstand")) QOLwhoswho++;
        }
    }

    // Step 2: Count number of perks and if they are greater than or equal to the required amount, put
    // them in the "perks to give" array.

    if (QOLjugg >= minPlayers) ArrayInsert(perksToGive, "specialty_armorvest", perksToGive.size);
    if (QOLreload >= minPlayers) ArrayInsert(perksToGive, "specialty_fastreload", perksToGive.size);
    if (QOLrevive >= minPlayers) ArrayInsert(perksToGive, "specialty_quickrevive", perksToGive.size);
    if (QOLdoubletap >= minPlayers) ArrayInsert(perksToGive, "specialty_rof", perksToGive.size);
    if (QOLstaminup >= minPlayers) ArrayInsert(perksToGive, "specialty_longersprint", perksToGive.size);
    if (QOLdeadshot >= minPlayers) ArrayInsert(perksToGive, "specialty_deadshot", perksToGive.size);
    if (QOLflakjacket >= minPlayers) ArrayInsert(perksToGive, "specialty_flakjacket", perksToGive.size);
    if (QOLmulekick >= minPlayers) ArrayInsert(perksToGive, "specialty_additionalprimaryweapon", perksToGive.size);
    if (QOLwhoswho >= minPlayers) ArrayInsert(perksToGive, "specialty_finalstand", perksToGive.size);

    // Step 3: If the perk made it into the "perks to give" array, let's give those perks to the player.
    foreach (QOLperk in perksToGive) self maps/mp/zombies/_zm_perks::give_perk(QOLperk);

    if (level.player_perk_mix_printin) {
        self iprintln("You were given a mix of perks from the alive players.");
    }
}

