#!/bin/bash
#
# positive test case where a new valid solution was submitted and has been validated

source /app/test/util/assert.sh

export MAKE_FIRST_CONTRIBUTION=yes

source /app/scripts/recompile_code_with_trusted_setup_size.sh 8

sed -i "s/THRESHOLD_DATE_FOR_FILE_ACCEPTANCE=.*/THRESHOLD_DATE_FOR_FILE_ACCEPTANCE=1/g" $DATABASE_FILE_PATH

printf 'entropyForSolutionGeneration' | source /app/scripts/initial_setup.sh
rm "$CHALLENGE_WORKDIR/response"
source /app/scripts/validationAndPreparation.sh

condition="$THRESHOLD_DATE_FOR_FILE_ACCEPTANCE -ge 1"
LINENO="Contribution date not adjusted"
assert "$condition" $LINENO
condition="$TRUSTED_SETUP_TURN -ge 1"

LINENO="Contribution turn not adjusted"
assert "$condition" $LINENO

#reseting values
source /app/scripts/recompile_code_with_trusted_setup_size.sh 26

