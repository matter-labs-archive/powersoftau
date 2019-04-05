. /app/variables.sh
chmod 600 /root/.ssh/id_rsa_worker
connect_to_sftp_server="sftp -i /root/.ssh/id_rsa_worker -o StrictHostKeyChecking=no $SSH_USER@$SFTP_ADDRESS"
