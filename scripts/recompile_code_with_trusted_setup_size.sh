#!/bin/bash
#
# recompiles the rust code for a specific size of the trusted setup. The size is given by the power 2**$1

SUBSITUTION_COMMAND='s/const REQUIRED_POWER: usize = [0-9][0-9];*/const REQUIRED_POWER: usize ='$1';/g'
sed -i "$SUBSITUTION_COMMAND" /app/src/bn256/mod.rs
sed -i "$SUBSITUTION_COMMAND" /app/src/small_bn256/mod.rs
. /app/scripts/build_all.sh