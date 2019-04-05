#!/bin/bash

#######################################################################
assert ()                 #  If condition false,
{                         #+ exit from script
                          #+ with appropriate error message.
  E_PARAM_ERR=98
  E_ASSERT_FAILED=99


  if [ -z "$2" ]          #  Not enough parameters passed
  then                    #+ to assert() function.
    return $E_PARAM_ERR   #  No damage done.
  fi

  lineno=$2

  if [ ! $1 ] 
  then
    echo "Assertion failed:  \"$1\""
    echo "File \"$0\", line $lineno"    # Give name of file and line number.
    exit $E_ASSERT_FAILED
  # else
  #   return
  #   and continue executing the script.
  fi  
} # Insert a similar assert() function into a script you need to debug.    
#######################################################################

sed -i "s/export THRESHOLD_DATE_FOR_FILE_ACCEPTANCE=.*/export THRESHOLD_DATE_FOR_FILE_ACCEPTANCE=40190405095223/g" /app/variables.sh

. /app/scripts/load_env_sshkey.sh

TURN_BEFORE_TEST=$TRUSTED_SETUP_TURN
source /app/scripts/validationAndPreparation.sh | grep "is not newer than"

condition="$TURN_BEFORE_TEST -le $TRUSTED_SETUP_TURN"
LINENO="Contribution turn not was adjusted, although upload was not newer than THRESHOLD_DATE_FOR_FILE_ACCEPTANCE"
assert "$condition" $LINENO
