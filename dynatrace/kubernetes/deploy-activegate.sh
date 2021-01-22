#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Deploying Dynatrace ActiveGate...${NC}"
echo ""

TENANT_ID=$(grep "DT_ENVIRONMENT_ID=" ../../configuration.conf | sed 's~DT_ENVIRONMENT_ID=[ \t]*~~')
DT_API_URL="https://$TENANT_ID.sprint.dynatracelabs.com"
DT_PAAS_TOKEN=$(grep "DT_PAAS_TOKEN=" ../../configuration.conf | sed 's~DT_PAAS_TOKEN=[ \t]*~~')

if [[ -f "Dynatrace-ActiveGate-Linux.sh" ]]; then
    rm -f Dynatrace-ActiveGate-Linux.sh
    echo "Removed Dynatrace-ActiveGate-Linux.sh"
fi

echo "Downloading ActiveGate..."
sudo curl -o Dynatrace-ActiveGate-Linux.sh -X GET "$DT_API_URL/api/v1/deployment/installer/gateway/unix/latest" -H "accept: application/octet-stream" -H "Authorization: Api-Token $DT_PAAS_TOKEN"

if [[ -f "Dynatrace-ActiveGate-Linux.sh" ]]; then
    echo "ActiveGate File is downloaded"
    echo "AG Install Starting..."
    sudo /bin/sh ./Dynatrace-ActiveGate-Linux.sh
    echo "AG Install Complete"
else
    echo "Downloading again..."
    sudo curl -o Dynatrace-ActiveGate-Linux.sh -X GET "$DT_API_URL/api/v1/deployment/installer/gateway/unix/latest" -H "accept: application/octet-stream" -H "Authorization: Api-Token $DT_PAAS_TOKEN"
fi

#echo "Waiting for AG to start"
#sleep 60
