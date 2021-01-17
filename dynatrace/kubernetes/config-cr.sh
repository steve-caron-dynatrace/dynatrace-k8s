#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Downloading Dynatrace OneAgent Operator Custom Resource definition template...${NC}"
echo ""

curl -o cr.yaml https://raw.githubusercontent.com/Dynatrace/dynatrace-oneagent-operator/master/deploy/cr.yaml

echo ""

ENVIRONMENT_ID=$(grep "DT_ENVIRONMENT_ID=" ../../configuration.conf | sed 's~DT_ENVIRONMENT_ID=[ \t]*~~')

if [ -n "$ENVIRONMENT_ID" ] 
then
	echo -e "${YLW}Creating the Custom Resource definition file...${NC}"
	sed -i "s/ENVIRONMENTID.live.dynatrace.com/$ENVIRONMENT_ID.sprint.dynatracelabs.com/" cr.yaml
        echo ""	
	echo -e "${YLW}Your Operator Custom Resource definition file is: ${NC}cr.yaml"
else
	echo -e "${YLW}ERROR: ${NC}Could not find a value for DT_ENVIRONMENT_ID in dynatrace.conf file." 
fi

echo ""


