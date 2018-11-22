#!/bin/sh

WORKINGDIR=~/websiteup
CHECKLIST=$WORKINGDIR/checklist.txt
TMP=$WORKINGDIR/tmp.txt
HTMLFILE=$WORKINGDIR/*.html*
PHPFILE=$WORKINGDIR/*.php*
EMAILCONTACT=enter@emailaddress.here
EMAILBODY=$WORKINGDIR/tmp-email.txt

# Removing old HTML and PHP files if they exist
printf "Removing old HTML and PHP files in $WORKINGDIR"
rm $HTMLFILE
rm $PHPFILE

# Start loop

# Runs through URL in $CHECKLIST through wget
cat $CHECKLIST

while read LINE <&3; do
printf "Checking $LINE..."
wget "$LINE" --no-check-certificate

# Checks if HTML & PHP files exist, then renames to $TMP file

if [ -f $HTMLFILE ]; then
   mv $HTMLFILE $TMP
fi

if [ -f $PHPFILE ]; then
   mv $PHPFILE $TMP
fi

# Check if downloaded file exists, if no file was 
# downloaded, then email alert is sent

if [ -f $TMP ]; then
   echo "$LINE is up."
   rm $TMP
else
   echo "$LINE is down."
   printf "Hello," > $EMAILBODY
   printf "The web server located at $LINE no longer appears to be serving a valid webpage." >> $EMAILBODY
   printf "Please investigate." >> $EMAILBODY
   mail s "ALERT: $LINE appears to be down" $EMAILCONTACT < $EMAILBODY
   rm $EMAILBODY
fi

done 3<$CHECKLIST
#End of loop
