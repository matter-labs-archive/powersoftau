#!/bin/bash

##Procedure:

#1. Client downloads latest challenge file from ftp-server via provided password-login
#2. Then he/she computes:
#3 cargo run --release --bin compute_constrained
#4. Uploades the response file to ftp-server via provided password-login


#Then the server is doing the following:
cargo run --release --bin verify_transform_constrained
name=challenge_old
if [[ -e $name ]] ; then
    i=0
    while [[ -e $name-$i ]] ; do
        let i++
    done
    name=$name-$i
fi

mv challenge $name

name=response_old
if [[ -e $name ]] ; then
    i=0
    while [[ -e $name-$i ]] ; do
        let i++
    done
    name=$name-$i
fi

mv response $name
mv new_challenge challenge

#Now, the next client can start with the usual "challenge file"
