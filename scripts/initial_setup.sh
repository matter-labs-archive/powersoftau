#!/bin/bash
#
# initiates the first challenge file

. /app/scripts/load_env_sshkey.sh

cd "$CHALLENGE_WORKDIR"

# First a new ceremony setup is created via:
set +e
rm challenge
rm response
rm new_challenge
set -e
# cargo run --release --bin new_constrained
/app/target/release/new_constrained

# Upload new challenge file to the challenges folder.
echo "put challenge" | $connect_to_sftp_server:challenges

MESSAGE="The ceremony is ready to get started! The first challenge was uploaded here: ${SFTP_ADDRESS}:challenges"
. /app/scripts/send_msg_to_gitter.sh "$MESSAGE"

#document new challenge in same folder
#copying the first upload is not supported, see here: https://superuser.com/questions/1166354/copy-file-on-sftp-to-another-directory-without-roundtrip
TIME=$(date +%s.%N)
cp challenge "challenge-$TIME"
echo "put challenge-$TIME" | $connect_to_sftp_server:challenges

#optional first computation
if [ ! -z "${MAKE_FIRST_CONTRIBUTION}" ]
then
	# cargo run --release --bin compute_constrained
	/app/target/release/compute_constrained
	# upload response
	echo "put response" | $connect_to_sftp_server:$SSH_USER
fi
