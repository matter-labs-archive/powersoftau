#!/bin/bash
#
# tests that no new challenge is created, if there is no newer upload

source /app/test/util/assert.sh

#tell the program that they have already validated something in the future:
sed -i "s/export THRESHOLD_DATE_FOR_FILE_ACCEPTANCE=.*/export THRESHOLD_DATE_FOR_FILE_ACCEPTANCE=40190405095223/g" /app/variables.sh
. /app/scripts/load_env_sshkey.sh

#store turn 
TURN_BEFORE_TEST=$TRUSTED_SETUP_TURN

#run code
source /app/scripts/validationAndPreparation.sh | grep "is not newer than"

#check that no new turn was created
condition="$TURN_BEFORE_TEST -le $TRUSTED_SETUP_TURN"
LINENO="Contribution turn not was adjusted, although upload was not newer than THRESHOLD_DATE_FOR_FILE_ACCEPTANCE"
assert "$condition" $LINENO
