PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

DISPLAY_RESULTS() {
  RESULT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p USING(atomic_number) JOIN types t USING(type_id) WHERE $CONDITION")
  IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< "$RESULT"
  echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
}

VERIFY_ARGUMENT(){
  local INPUT=$1
  if [[ $INPUT =~ ^[0-9]+$ ]]
  then
    CONDITION="e.atomic_number = '$INPUT'"
  else
    CONDITION="e.symbol = '$INPUT' or e.name = '$INPUT'"
  fi

  SELECT_ARGUMENT_RESULT=$($PSQL "SELECT * FROM elements e WHERE $CONDITION")
  if [[ -z $SELECT_ARGUMENT_RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    DISPLAY_RESULTS "$1"
  fi
}

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  VERIFY_ARGUMENT "$1"
fi
