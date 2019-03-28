#!/bin/bash

##Setup:
cd /app/
# First a new ceremony setup is created via:
rm challenge
rm response
rm new_challenge

cargo run --release --bin new_constrained

# Change to user worker and put into top level folder instead to josojo:
echo "put challenge" | sftp -i /root/.ssh/id_rsa_worker validationworker@trusted-setup.staging.gnosisdev.com:challenges
#optional first computation
cargo run --release --bin compute_constrained

# Change to user worker and put into top level folder instead to josojo:
echo "put response" | sftp -i /root/.ssh/id_rsa josojo@trusted-setup.staging.gnosisdev.com:josojo
