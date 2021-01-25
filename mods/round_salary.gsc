/*

    Functions for round salary are in this file.

*/

round_salary()
{
    level endon("end_game");
    for(;;) {
        salary = level.round_salary_amount;
        level waittill("end_of_round");
        pointsAward = (salary * level.round_number) - salary;
        players = getPlayers();
        foreach (player in players) {
            addPlayerPoints(player, pointsAward);
            if (level.round_salary_printin)
                player iPrintLn( "New round! Rewarded " + pointsAward + " points.");
        }
        wait 0.02;
    }
}

