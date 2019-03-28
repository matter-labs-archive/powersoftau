#!/bin/bash

FILES=`lftp -e "set ssl:key-file ~/.ssh/id_rsa2; cls; bye" sftp://validationworker:@trusted-setup.staging.gnosisdev.com`
FILES=${FILES//$challenges/}
NEWESTDATE=`cat /app/config/lastestContributionDate.txt`
if [[ -z "${NEWESTDATE}" ]]; then
  NEWESTDATE=0
fi
NEWESTDATE=`cat /app/config/lastestContributionTurn.txt`
if [[ -z "${TRUSTEDSETUPTURN}" ]]; then
  TRUSTEDSETUPTURN=1
fi
unset NEWESTFILE
for f in $FILES
do
	echo "Processing $f"
	DATE=` lftp -e "set ssl:key-file ~/.ssh/id_rsa2; cls -l --time-style=%FT%T $f/* --sort=date | head -1; bye" sftp://validationworker:@trusted-setup.staging.gnosisdev.com | awk '{print $6}' | sed 's/[^0-9]*//g'`
	echo "DATE is $DATE"
	if [ $DATE -gt $NEWESTDATE ]; then
		echo "found newer date"
		NEWESTDATE=$DATE
		NEWESTFILE=`lftp -e "set ssl:key-file ~/.ssh/id_rsa2; cls -l --time-style=%FT%T $f/* --sort=date | head -1; bye" sftp://validationworker:@trusted-setup.staging.gnosisdev.com | awk '{print $7}'`
		echo "newFileName is $NEWESTFILE"
	fi	
done

if [[ !  -z "${NEWESTFILE}" ]]; then
	echo "starting download; this could take a while..."
	sftp validationworker@trusted-setup.staging.gnosisdev.com:${NEWESTFILE} ~/.

	echo "verifying the submission; this could take a while..."
	cd /app/
	pwd
	cargo run --release --bin verify_transform

	echo "uploading to ftp server and documentation; this could take a while..."
	mv mv new_challenge challenge
	mv response "response-$NEWESTFILE-$TRUSTEDSETUPTURN"
	#upload new challenge file for next candiate
	echo "put challenge" | sftp validationworker@trusted-setup.staging.gnosisdev.com:challenges

	#document response from previous participant
	echo "put response-$NEWESTFILE-$TRUSTEDSETUPTURN" | sftp validationworker@trusted-setup.staging.gnosisdev.com:challenges

	#document new challenge file
	TIME=$(date +%s.%N)
	mv challenge "challenge-$TIME"
	echo "put challenge" | sftp validationworker@trusted-setup.staging.gnosisdev.com:challenges
fi
#safe new variables for next execution
echo $TRUSTEDSETUPTURN+1 > /app/config/LastestContributionTurn.txt
echo $NEWESTDATE > /app/config/LastestContributionDate.txt
