#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Downloading Dynatrace OneAgent Operator Custom Resource definition template...${NC}"
echo ""

LATEST_RELEASE=$(curl -s https://api.github.com/repos/dynatrace/dynatrace-oneagent-operator/releases/latest | grep tag_name | cut -d '"' -f 4) 
curl -o cr.yaml https://raw.githubusercontent.com/Dynatrace/dynatrace-oneagent-operator/$LATEST_RELEASE/deploy/cr.yaml

echo ""

read -p "Please enter your Dynatrace Environment ID (ex. https://ENVIRONMENT_ID>.sprint.dynatracelabs.com): " ENVIRONMENT_ID
echo ""
read -p "Environment ID = ${ENVIRONMENT_ID} . Is this correct? (y/n): " -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]] 
then
	sed -i "s/ENVIRONMENTID.live.dynatrace.com/$ENVIRONMENT_ID.sprint.dynatracelabs.com/" cr.yaml
	echo ""  
	echo -e "${YLM}Your Operator Custom Resource definition file is: cr.yaml${NC}"
fi

echo ""


