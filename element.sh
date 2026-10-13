#!/bin/bash

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi
if [[ $1 =~ ^[0-9]+$ ]]
then
  ELEMENT=$(psql -U freecodecamp -d periodic_table -tA -c "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p USING(atomic_number) JOIN types t USING(type_id) WHERE e.atomic_number = $1;")
else
  ELEMENT=$(psql -U freecodecamp -d periodic_table -tA -c "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p USING(atomic_number) JOIN types t USING(type_id) WHERE e.symbol = '$1' OR e.name = '$1';")
fi
if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
else
  echo "$ELEMENT" | while IFS='|' read -r ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
fi
