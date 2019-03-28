#!/bin/bash

##Setup:

# First a new ceremony setup is created via:
rm challenge
rm response
rm new_challenge

cargo run --release --bin new_constrained

# Change to user worker and put into top level folder instead to josojo:
echo "put challenge" | sftp validationworker@trusted-setup.staging.gnosisdev.com:challenges