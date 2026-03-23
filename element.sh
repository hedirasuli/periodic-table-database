#!/bin/bash

# Define the PSQL variable for database queries
# -t: tuples only, --no-align: clean output without tables
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if an argument was provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # Check if the input is an atomic_number (numeric) or symbol/name (string)
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # Query by atomic_number
    QUERY_RESULT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = $1")
  else
    # Query by symbol or name
    QUERY_RESULT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE symbol = '$1' OR name = '$1'")
  fi

  # Handle the result
  if [[ -z $QUERY_RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    # Parse the result string separated by '|'
    echo "$QUERY_RESULT" | while IFS="|" read ATOMIC_ID NAME SYMBOL TYPE MASS MELTING BOILING
    do
      echo "The element with atomic number $ATOMIC_ID is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
fi
# Database connection logic added
# Added error handling for missing elements
# Refactored query for better readability
# Final cleanup of the script
