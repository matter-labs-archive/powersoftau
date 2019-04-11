#!/bin/bash
#
# positive test case where a new valid solution was submitted and has been validated

source /app/test/util/assert.sh

export MAKE_FIRST_CONTRIBUTION=yes

sed -i 's/const REQUIRED_POWER: usize = [0-9][0-9];*/const REQUIRED_POWER: usize = 8;/g' /app/src/bn256/mod.rs
sed -i 's/const REQUIRED_POWER: usize = [0-9][0-9];*/const REQUIRED_POWER: usize = 8;/g' /app/src/small_bn256/mod.rs
sed -i "s/export THRESHOLD_DATE_FOR_FILE_ACCEPTANCE=.*/export THRESHOLD_DATE_FOR_FILE_ACCEPTANCE=1/g" /app/variables.sh

printf 'entropyForSolutionGeneration' | source /app/scripts/initial_setup.sh
source /app/scripts/validationAndPreparation.sh

condition="$THRESHOLD_DATE_FOR_FILE_ACCEPTANCE -ge 1"
LINENO="Contribution date not adjusted"
assert "$condition" $LINENO
condition="$TRUSTED_SETUP_TURN -ge 1"

LINENO="Contribution turn not adjusted"
assert "$condition" $LINENO

#reseting values
sed -i 's/const REQUIRED_POWER: usize = [0-9][0-9];*/const REQUIRED_POWER: usize = 26;/g' /app/src/bn256/mod.rs
sed -i 's/const REQUIRED_POWER: usize = [0-9][0-9];*/const REQUIRED_POWER: usize = 26;/g' /app/src/small_bn256/mod.rs
