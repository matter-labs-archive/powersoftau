#!/bin/bash
#
# test that the validation fails if bytes are changed in repsonse

source /app/test/util/assert.sh

. /app/scripts/load_env_sshkey.sh

export MAKE_FIRST_CONTRIBUTION=yes

sed -i 's/const REQUIRED_POWER: usize = [0-9][0-9];*/const REQUIRED_POWER: usize = 8;/g' /app/src/bn256/mod.rs
sed -i 's/const REQUIRED_POWER: usize = [0-9][0-9];*/const REQUIRED_POWER: usize = 8;/g' /app/src/small_bn256/mod.rs
sed -i "s/export THRESHOLD_DATE_FOR_FILE_ACCEPTANCE=.*/export THRESHOLD_DATE_FOR_FILE_ACCEPTANCE=1/g" /app/variables.sh

set -e

TURN_BEFORE_TEST=$TRUSTED_SETUP_TURN
printf 'entropyForSolutionGeneration' | source /app/scripts/initial_setup.sh
cp "$CHALLENGE_WORKDIR/response" "$CHALLENGE_WORKDIR/response-temp"
# read 1 byte at offset 40C
b_hex=$(xxd -seek $((16#40C)) -l 1 -ps "$CHALLENGE_WORKDIR/response" -)
# delete 3 least significant bits
b_dec=$(($((16#$b_hex)) & $((2#11111000))))
# write 1 byte back at offset 40C
printf "00040c: %02x" $b_dec | xxd -r - "$CHALLENGE_WORKDIR/response"
cd "$CHALLENGE_WORKDIR"
echo "put response" | $connect_to_sftp_server:$SSH_USER

source /app/scripts/validationAndPreparation.sh | grep "Verification failed"


condition="$THRESHOLD_DATE_FOR_FILE_ACCEPTANCE -ge 1"
LINENO="Contribution date not adjusted"
assert "$condition" $LINENO

condition="$TRUSTED_SETUP_TURN -le $TURN_BEFORE_TEST"
LINENO="Contribution turn not was adjusted, although upload was invalid"
assert "$condition" $LINENO

#reseting values
sed -i 's/const REQUIRED_POWER: usize = [0-9][0-9];*/const REQUIRED_POWER: usize = 26;/g' /app/src/bn256/mod.rs
sed -i 's/const REQUIRED_POWER: usize = [0-9][0-9];*/const REQUIRED_POWER: usize = 26;/g' /app/src/small_bn256/mod.rs