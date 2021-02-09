#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

DT_API_URL=$(grep "DT_API_URL=" ../../configuration.conf | sed 's~DT_API_URL=[ \t]*~~')
DT_CONFIG_TOKEN=$(grep "DT_CONFIG_TOKEN=" ../../configuration.conf | sed 's~DT_CONFIG_TOKEN=[ \t]*~~')

echo -e "${YLW}Deleting existing Alerting Profiles - 10 seconds${NC}"

./delete-alerting-profiles.sh

# wait, otherwise there are conflicts between delete and post resulting in constraint violations
sleep 10s

echo -e "${YLW}Creating alerting profiles${NC}"

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

