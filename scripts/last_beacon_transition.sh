#!/bin/bash

##Procedure -last setup:

#Server runs the beacon step with tbd beacon input. 
cargo run --release --bin beacon
cargo run --release --bin verify_transform