#!/bin/bash

# Periodic Table Element Information

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ELEMENT_INFO() {
  if [[ $1 ]]
  then
    USER_INPUT=$1
    # if user input is not a number
    if [[ ! $USER_INPUT =~ ^[0-9]+$ ]]
    then
      #if name provided
      if [[ $(expr length "$USER_INPUT") > 2 ]]
      then
        ELEMENT_AVAILABLE=$($PSQL "SELECT name FROM elements WHERE name='$USER_INPUT'")
        if [[ -z $ELEMENT_AVAILABLE ]]
        then
          echo "I could not find that element in the database."
        else
          ELEMENT_ID=$($PSQL "SELECT atomic_number FROM elements WHERE name='$USER_INPUT'")
          ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$USER_INPUT'")
          ELEMENT_TYPE=$($PSQL "SELECT type FROM properties INNER JOIN types ON properties.type_id = types.type_id WHERE atomic_number=$ELEMENT_ID")
          ELEMENT_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ELEMENT_ID")
          ELEMENT_MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ELEMENT_ID")
          ELEMENT_BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ELEMENT_ID")
          echo "The element with atomic number $ELEMENT_ID is $USER_INPUT ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_MASS amu. $USER_INPUT has a melting point of $ELEMENT_MELTING_POINT celsius and a boiling point of $ELEMENT_BOILING_POINT celsius."
        fi
      else # if symbol provided
        ELEMENT_AVAILABLE=$($PSQL "SELECT symbol FROM elements WHERE symbol='$USER_INPUT'")
        if [[ -z $ELEMENT_AVAILABLE ]]
        then
          echo "I could not find that element in the database."
        else
          ELEMENT_ID=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$USER_INPUT'")
          ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$USER_INPUT'")
          ELEMENT_TYPE=$($PSQL "SELECT type FROM properties INNER JOIN types ON properties.type_id = types.type_id WHERE atomic_number=$ELEMENT_ID")
          ELEMENT_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ELEMENT_ID")
          ELEMENT_MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ELEMENT_ID")
          ELEMENT_BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ELEMENT_ID")
          echo "The element with atomic number $ELEMENT_ID is $ELEMENT_NAME ($USER_INPUT). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_MASS amu. $ELEMENT_NAME has a melting point of $ELEMENT_MELTING_POINT celsius and a boiling point of $ELEMENT_BOILING_POINT celsius."
        fi
      fi
    else
      #if atomic number is not in database
      ELEMENT_AVAILABLE=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$USER_INPUT")
      if [[ -z $ELEMENT_AVAILABLE ]]
      then
        echo "I could not find that element in the database."
      else
        ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$USER_INPUT")
        ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$USER_INPUT")
        ELEMENT_TYPE=$($PSQL "SELECT type FROM properties INNER JOIN types ON properties.type_id = types.type_id WHERE atomic_number=$USER_INPUT")
        ELEMENT_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$USER_INPUT")
        ELEMENT_MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$USER_INPUT")
        ELEMENT_BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$USER_INPUT")
        echo "The element with atomic number $USER_INPUT is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_MASS amu. $ELEMENT_NAME has a melting point of $ELEMENT_MELTING_POINT celsius and a boiling point of $ELEMENT_BOILING_POINT celsius."
      fi
    fi
  else
    echo "Please provide an element as an argument."
  fi
}

ELEMENT_INFO $1
