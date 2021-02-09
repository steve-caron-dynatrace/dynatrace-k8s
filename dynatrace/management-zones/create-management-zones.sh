#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

DT_API_URL=$(grep "DT_API_URL=" ../../configuration.conf | sed 's~DT_API_URL=[ \t]*~~')

DT_CONFIG_TOKEN=$(grep "DT_CONFIG_TOKEN=" ../../configuration.conf | sed 's~DT_CONFIG_TOKEN=[ \t]*~~')

echo -e "${YLW}Deleting existing Management Zones - 30 seconds${NC}"

./delete-management-zones.sh

# wait, otherwise there are conflicts between delete and post resulting in constraint violations
sleep 30s

echo -e "${YLW}Creating Management Zone${NC}"
RESPONSE=$(curl -X POST "$DT_API_URL/api/config/v1/managementZones" -H "accept: application/json; charset=utf-8" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -H "Content-Type: application/json; charset=utf-8" -d @mz-app-sockshop.json)
echo -e "${YLW}$RESPONSE${NC}"

echo -e "${YLW}Creating Management Zone${NC}"
RESPONSE=$(curl -X POST "$DT_API_URL/api/config/v1/managementZones" -H "accept: application/json; charset=utf-8" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -H "Content-Type: application/json; charset=utf-8" -d @mz-app-easytravel.json)
echo -e "${YLW}$RESPONSE${NC}"

echo -e "${YLW}Creating Management Zone${NC}"
RESPONSE=$(curl -X POST "$DT_API_URL/api/config/v1/managementZones" -H "accept: application/json; charset=utf-8" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -H "Content-Type: application/json; charset=utf-8" -d @mz-app-hipstershop.json)
echo -e "${YLW}$RESPONSE${NC}"

echo -e "${YLW}Creating Management Zone${NC}"
RESPONSE=$(curl -X POST "$DT_API_URL/api/config/v1/managementZones" -H "accept: application/json; charset=utf-8" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -H "Content-Type: application/json; charset=utf-8" -d @mz-k8s-infra.json)
echo -e "${YLW}$RESPONSE${NC}"