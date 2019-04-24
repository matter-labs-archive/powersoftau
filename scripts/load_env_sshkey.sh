#!/bin/bash
#
# run the varariables.sh to load all enviromental variables set sets common aliases

. $DATABASE_FILE_PATH

# If `SSH_FILE_PATH` is empty/unset
if [ -z "$SSH_FILE_PATH" ]
then
    # Set default SSH_FILE_PATH
    SSH_FILE_PATH=/root/.ssh/id_rsa_worker
fi

chmod 600 $SSH_FILE_PATH
connect_to_sftp_server="sftp -i $SSH_FILE_PATH -o StrictHostKeyChecking=no $SSH_USER@$SFTP_ADDRESS"
