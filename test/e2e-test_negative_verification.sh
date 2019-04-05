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

. /app/scripts/load_env_sshkey.sh

export MAKEFIRSTCONTRIBUTION=yes

sed -i 's/const REQUIRED_POWER: usize = [0-9][0-9];*/const REQUIRED_POWER: usize = 8;/g' /app/src/bn256/mod.rs
sed -i 's/const REQUIRED_POWER: usize = [0-9][0-9];*/const REQUIRED_POWER: usize = 8;/g' /app/src/small_bn256/mod.rs
sed -i "s/export THRESHOLD_DATE_FOR_FILE_ACCEPTANCE=.*/export THRESHOLD_DATE_FOR_FILE_ACCEPTANCE=1/g" /app/variables.sh

TURN_BEFORE_TEST=$TRUSTED_SETUP_TURN
printf 'entropyForSolutionGeneration' | source /app/scripts/initial_setup.sh
cp /app/response /app/response-temp
# read 1 byte at offset 40C
b_hex=$(xxd -seek $((16#40C)) -l 1 -ps /app/response -)
# delete 3 least significant bits
b_dec=$(($((16#$b_hex)) & $((2#11111000))))
# write 1 byte back at offset 40C
printf "00040c: %02x" $b_dec | xxd -r - /app/response
diff  /app/response /app/response-temp
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