
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

PASS='\033[0;32m[\xE2\x9C\x94]\033[0m'
FAIL='\033[0;31m[\xE2\x9D\x8C]\033[0m'

FAILED=0

function checkResponse() {
	if [ $? -eq 0 ]; then 
		echo -e "${PASS}"
	else 
		echo -e "${FAIL}"
		FAILED=1
	fi
}

function checkResponseInverse() {
	if [ $? -eq 0 ]; then 
		echo -e "${FAIL}"
		FAILED=1
	else 
		echo -e "${PASS}"
	fi
}

function assertAllPass() {
	if ((FAILED)); then
		echo "At least one test Failed"
		exit 1
	fi
}