#!/bin/bash
set -e 
##Procedure -last setup:

#Server runs the beacon step with tbd beacon input. 
if [[ ! -z "${CONSTRAINED}" ]]; then
	cargo run --release --bin beacon_constrained
	cargo run --release --bin verify_transform_constrained
else
	cargo run --release --bin beacon
	cargo run --release --bin verify_transform
fi

