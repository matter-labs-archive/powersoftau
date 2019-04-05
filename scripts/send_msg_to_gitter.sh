#!/bin/bash
. /app/scripts/load_env_sshkey.sh

curl -d message="$1" https://webhooks.gitter.im/e/$KEY_GITTER_TRUSTED_SETUP_ROOM
