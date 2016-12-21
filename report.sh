#!/usr/bin/env bash

DAY=$1
SEARCH=$2
YEAR=2016
MONTH=12
EMAIL="ardeshir.org@gmail.com"

function help {
    echo "usage: ${0} <day> <search> <email>"
    exit 1 
}

if [ $# -lt 3 ]; then
  help
fi


aws s3 cp s3://ditech-rms-elb-accesslogs-us-east-1-masterbucket/elasticloadbalancing/security1-prod-app-elb/AWSLogs/143543988794/elasticloadbalancing/us-east-1/$YEAR/$MONTH/$DAY/ .  --recursive

cat *.log | grep "$SEARCH" | awk '{print $3}' | awk -F\: '{print $1}' | sort | uniq -c | sort -n > checked-for-$SEARCH-on-$YEAR-$MONTH-$DAY.logs

#sendmail -s "Check for ${SEARCH} on ${YEAR}-${MONTH}-${DAY}" $EMAIL < checked-for-$SEARCH-on-$YEAR-$MONTH-$DAY.logs 

LANG=en_EN

# ARG
FROM="logrepots@aws.com"
TO="ardeshir.org@gmail.com"
SUBJECT="LOG REPORT"

MSG=$(cat checked-for-$SEARCH-on-$YEAR-$MONTH-$DAY.logs)


cat <<EOF | /usr/sbin/sendmail -t
From: ${FROM}
To: ${TO}
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary=frontier
Subject: ${SUBJECT}

Content-Type: $(echo ${MSG})


${MSG}

EOF



rm -rf ./*.log
