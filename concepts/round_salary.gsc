round_salary()
{
    if (!level.round_salary) {
        return;
    }
    level endon("end_game");
    level waittill("start_of_round");
    while (true) {
        salary = level.round_salary_amount;
        level waittill("start_of_round");
        pointsAward = (salary * level.round_number) - salary;
        players = getPlayers();
        foreach (player in players) {
            player.score += pointsAward;
            player iPrintLn( "Points Awarded For Round Completion: " + pointsAward );
        }
    }
}