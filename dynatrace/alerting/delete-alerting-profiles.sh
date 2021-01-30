#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

TENANT_ID=$(grep "DT_ENVIRONMENT_ID=" ../../configuration.conf | sed 's~DT_ENVIRONMENT_ID=[ \t]*~~')
DT_API_URL="https://$TENANT_ID.sprint.dynatracelabs.com"
DT_CONFIG_TOKEN=$(grep "DT_CONFIG_TOKEN=" ../../configuration.conf | sed 's~DT_CONFIG_TOKEN=[ \t]*~~')

echo -e "${YLW}Deleting alerting profiles${NC}"

ALERTING_PROFILES=$(curl  -X GET "$DT_API_URL/api/config/v1/alertingProfiles" -H  "accept: application/json; charset=utf-8" -H  "Authorization: Api-Token $DT_CONFIG_TOKEN")

SOCKSHOP_CARTS_DEV=$(echo $ALERTING_PROFILES | jq -c -r '.values | .[] | select(.name == "sockshop carts dev") | .id')
SOCKSHOP_DEVOPS=$(echo $ALERTING_PROFILES | jq -c -r '.values | .[] | select(.name == "sockshop devops") | .id')
EASYTRAVEL=$(echo $ALERTING_PROFILES | jq -c -r '.values | .[] | select(.name == "easytravel") | .id')
HIPSTERSHOP=$(echo $ALERTING_PROFILES | jq -c -r '.values | .[] | select(.name == "hipstershop") | .id')
K8S_INFRA=$(echo $ALERTING_PROFILES | jq -c -r '.values | .[] | select(.name == "k8s infra") | .id')

if [ ! -z "$SOCKSHOP_CARTS_DEV" ]
then
    RESPONSE=$(curl -X DELETE -H  "accept: */*" -H  "Authorization: Api-Token $DT_CONFIG_TOKEN" "$DT_API_URL/api/config/v1/alertingProfiles/$SOCKSHOP_CARTS_DEV");
    echo -e "${YLW}$RESPONSE${NC}"
fi
if [ ! -z "$SOCKSHOP_DEVOPS" ]
then
    RESPONSE=$(curl -X DELETE -H  "accept: */*" -H  "Authorization: Api-Token $DT_CONFIG_TOKEN" "$DT_API_URL/api/config/v1/alertingProfiles/$SOCKSHOP_DEVOPS");
    echo -e "${YLW}$RESPONSE${NC}"
fi
if [ ! -z "$EASYTRAVEL" ]
then
    RESPONSE=$(curl -X DELETE -H  "accept: */*" -H  "Authorization: Api-Token $DT_CONFIG_TOKEN" "$DT_API_URL/api/config/v1/alertingProfiles/$EASYTRAVEL");
    echo -e "${YLW}$RESPONSE${NC}"
fi
if [ ! -z "$HIPSTERSHOP" ]
then
    RESPONSE=$(curl -X DELETE -H  "accept: */*" -H  "Authorization: Api-Token $DT_CONFIG_TOKEN" "$DT_API_URL/api/config/v1/alertingProfiles/$HIPSTERSHOP");
    echo -e "${YLW}$RESPONSE${NC}"
fi
if [ ! -z "$K8S_INFRA" ]
then
    RESPONSE=$(curl -X DELETE -H  "accept: */*" -H  "Authorization: Api-Token $DT_CONFIG_TOKEN" "$DT_API_URL/api/config/v1/alertingProfiles/$K8S_INFRA");
    echo -e "${YLW}$RESPONSE${NC}"
fi

