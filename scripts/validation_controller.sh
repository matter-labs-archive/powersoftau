#!/bin/bash

PIDFILE=/root/forever.pid
PID=$(cat $PIDFILE)
ps -p $PID > /dev/null 2>&1
if [ $? -eq 0 ]
then
echo "Job is already running"
exit 1
else
	## Process not found assume not running
	echo $$ > $PIDFILE
	if [ $? -ne 0 ]
	then
	  echo "Could not create PID file"
	  exit 1
	fi
	## Start the actual program
	echo "Cron starts the valiation job"
	. /app/scripts/validationAndPreparation.sh 
fi	

