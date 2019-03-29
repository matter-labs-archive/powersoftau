#!/bin/bash

FILES=`lftp sftp://validationworker:@trusted-setup.staging.gnosisdev.com -e 'set sftp:connect-program "ssh -a -x -i /root/.ssh/id_rsa_worker";cls;bye'`

#no contribution in folder challenges expected
FILES=${FILES//$challenges/}
NEWESTDATE=`cat /app/config/lastestContributionDate.txt`
if [[ -z "${NEWESTDATE}" ]]; then
  NEWESTDATE=0
fi

TRUSTEDSETUPTURN=`cat /app/config/lastestContributionTurn.txt`
if [[ -z "${TRUSTEDSETUPTURN}" ]]; then
  TRUSTEDSETUPTURN=1
fi

unset NEWESTFILE

for f in $FILES
do
	echo "Processing $f"
	DATE=`lftp sftp://validationworker:@trusted-setup.staging.gnosisdev.com -e 'set sftp:connect-program "ssh -a -x -i /root/.ssh/id_rsa_worker"; cls -l --time-style=%FT%T '$f'/* --sort=date | head -1; bye' | awk '{print $6}' | sed 's/[^0-9]*//g'`
	echo "DATE is $DATE"
	if [ $DATE -gt $NEWESTDATE ]; then
		echo "found newer contribution"
		NEWESTDATE=$DATE
		NEWESTFILE=`lftp sftp://validationworker:@trusted-setup.staging.gnosisdev.com -e 'set sftp:connect-program "ssh -a -x -i /root/.ssh/id_rsa_worker"; cls -l --time-style=%FT%T '$f'/* --sort=date | head -1; bye' | awk '{print $7}'`
		echo "newest contribution is $NEWESTFILE"
	fi	
done

#If a new contribution is found, do verification and preparation for next step
if [[ !  -z "${NEWESTFILE}" ]]; then|
	cd /app/
	echo "starting download; this could take a while..."
	sftp -i /root/.ssh/id_rsa_worker validationworker@trusted-setup.staging.gnosisdev.com:${NEWESTFILE} ~/.

	echo "verifying the submission; this could take a while..."
	cargo run --release --bin verify_transform_constrained

	echo "uploading to ftp server and documentation; this could take a while..."
	mv mv new_challenge challenge
	mv response "response-$NEWESTFILE-$TRUSTEDSETUPTURN"
	
	#upload new challenge file for next candiate
	echo "put challenge" | sftp -i /root/.ssh/id_rsa_worker validationworker@trusted-setup.staging.gnosisdev.com:challenges

	#document response from previous participant
	echo "put response-$NEWESTFILE-$TRUSTEDSETUPTURN" | sftp -i /root/.ssh/id_rsa_worker validationworker@trusted-setup.staging.gnosisdev.com:challenges

	#document new challenge file
	TIME=$(date +%s.%N)
	cp challenge "challenge-$TIME"
	echo "put challenge-$TIME" | sftp -i /root/.ssh/id_rsa_worker validationworker@trusted-setup.staging.gnosisdev.com:challenges
fi

#safe new variables for next execution
echo $TRUSTEDSETUPTURN+1 > /app/config/LastestContributionTurn.txt
echo $NEWESTDATE > /app/config/LastestContributionDate.txt
