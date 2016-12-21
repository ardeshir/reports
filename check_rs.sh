#!/usr/bin/env bash

DAY=$1
SEARCH=$2
YEAR=2016
MONTH=12

function help {
    echo "usage: ${0} <day> <search>"
    exit 1 
}

if [ $# -lt 1 ]; then
  help
fi


aws s3 cp s3://ditech-rms-elb-accesslogs-us-east-1-masterbucket/elasticloadbalancing/security1-prod-app-elb/AWSLogs/143543988794/elasticloadbalancing/us-east-1/$YEAR/$MONTH/$DAY/ .  --recursive

cat *.log | grep "$SEARCH" | awk '{print $3}' | awk -F\: '{print $1}' | sort | uniq -c | sort -n

rm -rf ./*.log
