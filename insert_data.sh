#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "truncate games, teams")
cat  games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $WINNER != "winner" || $OPPONENT != "opponent" ]]
then
echo $($PSQL "insert into teams(name) SELECT '$OPPONENT' WHERE NOT EXISTS (SELECT 1 FROM teams WHERE name = '$OPPONENT')")
echo $($PSQL "insert into teams(name) SELECT '$WINNER' WHERE NOT EXISTS (SELECT 1 FROM teams WHERE name = '$WINNER')")
fi
if [[ $YEAR != "year" || $ROUND != "round" || $WINNER_GOALS != "winner_goals" || $OPPONENT_GOALS != "opponent_goals" ]]
then
WINNER_ID=$($PSQL "select team_id from teams WHERE name='$WINNER'")
OPPONENT_ID=$($PSQL "select team_id from teams WHERE name='$OPPONENT'")
echo $($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
fi
done