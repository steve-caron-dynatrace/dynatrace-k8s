#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

TENANT_ID=$(grep "DT_ENVIRONMENT_ID=" ../../configuration.conf | sed 's~DT_ENVIRONMENT_ID=[ \t]*~~')
DT_API_URL="https://$TENANT_ID.sprint.dynatracelabs.com"
DT_CONFIG_TOKEN=$(grep "DT_CONFIG_TOKEN=" ../../configuration.conf | sed 's~DT_CONFIG_TOKEN=[ \t]*~~')

echo -e "${YLW}Creating anomaly detection rules${NC}"

MZ=$(curl  -X GET "$DT_API_URL/api/config/v1/managementZones" -H  "accept: application/json; charset=utf-8" -H  "Authorization: Api-Token $DT_CONFIG_TOKEN")

MZ_ID=$(echo $MZ | jq -c -r '.values | .[] | select(.name == "app:easytravel") | .id')
PROFILE=$(cat ./alerting-profile-easytravel.json | sed "s/<MZ_ID>/$MZ_ID/")

RESPONSE=$(curl -X POST "$DT_API_URL/api/config/v1/alertingProfiles" -H "accept: application/json; charset=utf-8" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -H "Content-Type: application/json; charset=utf-8" -d "$PROFILE")
echo -e "${YLW}$RESPONSE${NC}"

MZ_ID=$(echo $MZ | jq -c -r '.values | .[] | select(.name == "app:hipstershop") | .id')
PROFILE=$(cat ./alerting-profile-hipstershop.json | sed "s/<MZ_ID>/$MZ_ID/")

RESPONSE=$(curl -X POST "$DT_API_URL/api/config/v1/alertingProfiles" -H "accept: application/json; charset=utf-8" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -H "Content-Type: application/json; charset=utf-8" -d "$PROFILE")
echo -e "${YLW}$RESPONSE${NC}"

MZ_ID=$(echo $MZ | jq -c -r '.values | .[] | select(.name == "k8s:infra") | .id')
PROFILE=$(cat ./alerting-profile-k8s-infra.json | sed "s/<MZ_ID>/$MZ_ID/")

RESPONSE=$(curl -X POST "$DT_API_URL/api/config/v1/alertingProfiles" -H "accept: application/json; charset=utf-8" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -H "Content-Type: application/json; charset=utf-8" -d "$PROFILE")
echo -e "${YLW}$RESPONSE${NC}"

MZ_ID=$(echo $MZ | jq -c -r '.values | .[] | select(.name == "app:sockshop") | .id')
PROFILE=$(cat ./alerting-profile-sockshop-carts-dev.json | sed "s/<MZ_ID>/$MZ_ID/")

RESPONSE=$(curl -X POST "$DT_API_URL/api/config/v1/alertingProfiles" -H "accept: application/json; charset=utf-8" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -H "Content-Type: application/json; charset=utf-8" -d "$PROFILE")
echo -e "${YLW}$RESPONSE${NC}"

PROFILE=$(cat ./alerting-profile-sockshop-devops.json | sed "s/<MZ_ID>/$MZ_ID/")

RESPONSE=$(curl -X POST "$DT_API_URL/api/config/v1/alertingProfiles" -H "accept: application/json; charset=utf-8" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -H "Content-Type: application/json; charset=utf-8" -d "$PROFILE")
echo -e "${YLW}$RESPONSE${NC}"

