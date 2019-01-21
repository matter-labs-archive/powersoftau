#!/bin/bash

##Setup:

# First a new constraint system is created via:
rm challenge
rm response
rm new_challenge

cargo run --release --bin new_constrained

