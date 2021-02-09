#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Please enter your Dynatrace credentials as requested below: ${NC}"
API_URL=""
read -p "API URL (see the README for more details): " API_URL
API_TOKEN=""
read -p "API token: " API_TOKEN
PAAS_TOKEN=""
read -p "PaaS token: " PAAS_TOKEN
CONFIG_TOKEN=$API_TOKEN
echo -e "${YLW}Please confirm these are correct: ${NC}"
echo "API_URL: " $API_URL
echo "API token: " $API_TOKEN
echo "PaaS token: " $PAAS_TOKEN
 
read -p "Is this correct? (y/n): " -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]] 
then
	sed -i -r 's~DT_API_URL=(.*)~DT_API_URL\='"$API_URL"'~' ./configuration.conf
	sed -i -r 's~DT_API_TOKEN=(.*)~DT_API_TOKEN\='"$API_TOKEN"'~' ./configuration.conf
	sed -i -r 's~DT_PAAS_TOKEN=(.*)~DT_PAAS_TOKEN\='"$PAAS_TOKEN"'~' ./configuration.conf
	sed -i -r 's~DT_CONFIG_TOKEN=(.*)~DT_CONFIG_TOKEN\='"$CONFIG_TOKEN"'~' ./configuration.conf
fi

echo ""


