
FILES=`lftp -e "set ssl:key-file ~/.ssh/id_rsa; cls; bye" sftp://josojo:@trusted-setup.staging.gnosisdev.com`
if [[ -z "${NEWESTDATE}" ]]; then
  NEWESTDATE=0
fi
if [[ -z "${TRUSTEDSETUPTURN}" ]]; then
  TRUSTEDSETUPTURN=1
fi
unset NEWESTFILE
for f in $FILES
do
	echo "Processing $f"
	DATE=` lftp -e "set ssl:key-file ~/.ssh/id_rsa; cls -l --time-style=%FT%T $f/* --sort=date | head -1; bye" sftp://josojo:@trusted-setup.staging.gnosisdev.com | awk '{print $6}' | sed 's/[^0-9]*//g'`
	echo "DATE is $DATE"
	if [ $DATE -gt $NEWESTDATE ]; then
		echo "found newer date"
		NEWESTDATE=$DATE
		NEWESTFILE=`lftp -e "set ssl:key-file ~/.ssh/id_rsa; cls -l --time-style=%FT%T $f/* --sort=date | head -1; bye" sftp://josojo:@trusted-setup.staging.gnosisdev.com | awk '{print $7}'`
		echo "newFileName $NEWESTFILE"
	fi	
done

if [[ !  -z "${NEWESTFILE}" ]]; then
	echo "starting download; this could take a while..."
	sftp josojo@trusted-setup.staging.gnosisdev.com:${NEWESTFILE} ~/

	echo "verifying the submission; this could take a while..."
	cargo run --release --bin verify_transform


	echo "uploading to ftp server and documentation; this could take a while..."
	mv mv new_challenge challenge
	mv response "response-$NEWESTFILE-$TRUSTEDSETUPTURN"

	#upload new challenge file for next candiate
	echo "put challenge" | sftp josojo@trusted-setup.staging.gnosisdev.com:josojo

	#document response from previous participant
	echo "put response-$NEWESTFILE-$TRUSTEDSETUPTURN" | sftp josojo@trusted-setup.staging.gnosisdev.com:josojo

	#document new challenge file
	TIME=$(date +%s.%N)
	mv challenge "challenge-$TIME"
	echo "put challenge" | sftp josojo@trusted-setup.staging.gnosisdev.com:josojo

fi
export TRUSTEDSETUPTURN=$TRUSTEDSETUPTURN+1
export NEWESTDATE=$NEWESTDATE  