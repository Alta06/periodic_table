#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
TEST_ATOMIC_NUMBER() {
 NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1")
  TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number=$1")
  MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$1")
  MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$1")
  BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$1")
    if [[ -z $NAME ]]
      then 
      echo "I could not find that element in the database."
      else
      echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    fi
}

TEST_SYMBOL() {
  #gérer le cas de réponse avec le nom de l'élément
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$1'")
  TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) INNER JOIN elements USING(atomic_number) WHERE name='$1'")
  MASS=$($PSQL "SELECT atomic_mass FROM properties INNER JOIN elements USING(atomic_number) WHERE name='$1'")
  MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties INNER JOIN elements USING(atomic_number) WHERE name='$1'")
  BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) WHERE name='$1'")
    if [[ -z $ATOMIC_NUMBER ]]
      then 
      echo "I could not find that element in the database."
      else
      echo "The element with atomic number $ATOMIC_NUMBER is $1 ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $1 has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    fi
}

TEST_NAME() {
   NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$1'")
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
  TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) INNER JOIN elements USING(atomic_number) WHERE symbol='$1'")
  MASS=$($PSQL "SELECT atomic_mass FROM properties INNER JOIN elements USING(atomic_number) WHERE symbol='$1'")
  MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties INNER JOIN elements USING(atomic_number) WHERE symbol='$1'")
  BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) WHERE symbol='$1'")
    if [[ -z $NAME ]]
      then
      echo "$1 I could not find that element in the database."
      else
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($1). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    fi
}

if [[ ! $1 ]]
  then
  echo "Please provide an element as an argument."

elif [[ $1 == [0-9]* ]]
  then
  TEST_ATOMIC_NUMBER $1

elif [[ $1 =~ [A-Za-z]{3,} ]]
  then
  TEST_SYMBOL $1

elif [[ $1 =~ [A-Z]{1,2} ]]
  then
  TEST_NAME $1

fi



