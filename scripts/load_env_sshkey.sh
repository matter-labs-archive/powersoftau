#!/bin/bash
#
# run the varariables.sh to load all enviromental variables set sets common aliases

. /app/variables.sh
chmod 600 /root/.ssh/id_rsa_worker
connect_to_sftp_server="sftp -i /root/.ssh/id_rsa_worker -o StrictHostKeyChecking=no $SSH_USER@$SFTP_ADDRESS"

if [[ -z "${THRESHOLD_DATE_FOR_FILE_ACCEPTANCE}" ]]; then
  echo "THRESHOLD_DATE_FOR_FILE_ACCEPTANCE should be set"
  exit 1
fi

if [[ -z "${TRUSTED_SETUP_TURN}" ]]; then
  echo "TRUSTED_SETUP_TURN should be set"
  exit 1
fi