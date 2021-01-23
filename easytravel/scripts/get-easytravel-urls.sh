#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

START=$(date +%s)
DIFF=0
# while not all public urls are available or more than 6 minutes have elapsed
while [ -z $WWW_URL ] && [ $DIFF -lt 360 ];
do
      WWW_URL=http://$(kubectl describe svc easytravel-www -n easytravel | grep "LoadBalancer Ingress:" | sed 's/LoadBalancer Ingress:[ \t]*//')
  echo -n .
  sleep 4
  NOW=$(date +%s)
  DIFF=$(( $NOW - $START ))
done

sed -i -r 's~EASYTRAVEL_URL=(.*)~EASYTRAVEL_URL\='"$WWW_URL"'~' ../../configuration.conf

echo ""
echo -e "${YLW}EasyTravel:${NC} $WWW_URL"
echo ""
