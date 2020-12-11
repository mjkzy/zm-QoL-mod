round_salary()
{
    level endon( "end_game" );
    level waittill( "start_of_round" );
    while ( true )
    {
        salary = getDvarIntDefault( "QOL_round_salary_points_per_round", 50 );
        level waittill( "start_of_round" );
        pointsAward = ( salary * level.round_number ) - salary;
        players = getPlayers();
        foreach ( player in players )
        {
            player.score += pointsAward;
            player iPrintLn( "Points Awarded For Round Completion: " + pointsAward );
        }
    }
}