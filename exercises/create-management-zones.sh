#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

TENANT_ID=$(grep "DT_ENVIRONMENT_ID=" ../configuration.conf | sed 's~DT_ENVIRONMENT_ID=[ \t]*~~')
DT_API_URL="https://$TENANT_ID.sprint.dynatracelabs.com"
DT_CONFIG_TOKEN=$(grep "DT_CONFIG_TOKEN=" ../configuration.conf | sed 's~DT_CONFIG_TOKEN=[ \t]*~~')

./delete-management-zones.sh

echo -e "${YLW}Creating Management Zone${NC}"
RESPONSE=$(curl -X POST "$DT_API_URL/api/config/v1/managementZones" -H "accept: application/json; charset=utf-8" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -H "Content-Type: application/json; charset=utf-8" -d @../dynatrace/mz-app-sockshop.json)
echo -e "${YLW}$RESPONSE${NC}"

echo -e "${YLW}Creating Management Zone${NC}"
RESPONSE=$(curl -X POST "$DT_API_URL/api/config/v1/managementZones" -H "accept: application/json; charset=utf-8" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -H "Content-Type: application/json; charset=utf-8" -d @../dynatrace/mz-app-easytravel.json)
echo -e "${YLW}$RESPONSE${NC}"

echo -e "${YLW}Creating Management Zone${NC}"
RESPONSE=$(curl -X POST "$DT_API_URL/api/config/v1/managementZones" -H "accept: application/json; charset=utf-8" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -H "Content-Type: application/json; charset=utf-8" -d @../dynatrace/mz-app-hipstershop.json)
echo -e "${YLW}$RESPONSE${NC}"

echo -e "${YLW}Creating Management Zone${NC}"
RESPONSE=$(curl -X POST "$DT_API_URL/api/config/v1/managementZones" -H "accept: application/json; charset=utf-8" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -H "Content-Type: application/json; charset=utf-8" -d @../dynatrace/mz-k8s-infra.json)
echo -e "${YLW}$RESPONSE${NC}"