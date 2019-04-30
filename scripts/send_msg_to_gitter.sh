#!/bin/bash
#
# sends a message to the gitter channel
# param 1: Message to be send

. /app/scripts/load_env_sshkey.sh

 curl -X post -H "Content-Type: application/json" -H "Authorization: Bearer $GITTER_ACCESS_TOKEN" -d "{\"text\":\"$1\"}" "https://api.gitter.im/v1/rooms/$GITTER_ROOM/chatMessages"