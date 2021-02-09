#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

DT_API_URL=$(grep "DT_API_URL=" ../../configuration.conf | sed 's~DT_API_URL=[ \t]*~~')
DT_CONFIG_TOKEN=$(grep "DT_CONFIG_TOKEN=" ../../configuration.conf | sed 's~DT_CONFIG_TOKEN=[ \t]*~~')

MZ_LIST=$(curl  -X GET "$DT_API_URL/api/config/v1/managementZones" -H  "accept: application/json; charset=utf-8" -H  "Authorization: Api-Token $DT_CONFIG_TOKEN")

MG_ID_SOCKSHOP=$(echo "$MZ_LIST" | jq -c -r '.values | .[] | select(.name == "app:sockshop") | .id')
MG_ID_EASYTRAVEL=$(echo "$MZ_LIST" | jq -c -r '.values | .[] | select(.name == "app:easytravel") | .id')
MG_ID_HIPSTERSHOP=$(echo "$MZ_LIST" | jq -c -r '.values | .[] | select(.name == "app:hipstershop") | .id')
MG_ID_INFRA=$(echo "$MZ_LIST" | jq -c -r '.values | .[] | select(.name == "k8s:infra") | .id')

if [ ! -z "$MG_ID_SOCKSHOP" ]
then
    echo -e "${YLW}Deleting Management Zone${NC}"
    RESPONSE=$(curl -X DELETE -H  "accept: */*" -H  "Authorization: Api-Token $DT_CONFIG_TOKEN" "$DT_API_URL/api/config/v1/managementZones/$MG_ID_SOCKSHOP");
    echo -e "${YLW}$RESPONSE${NC}"
fi

if [ ! -z "$MG_ID_EASYTRAVEL" ]
then
    echo -e "${YLW}Deleting Management Zone${NC}"
    RESPONSE=$(curl -X DELETE -H  "accept: */*" -H  "Authorization: Api-Token $DT_CONFIG_TOKEN" "$DT_API_URL/api/config/v1/managementZones/$MG_ID_EASYTRAVEL");
    echo -e "${YLW}$RESPONSE${NC}"
fi

if [ ! -z "$MG_ID_HIPSTERSHOP" ]
then
    echo -e "${YLW}Deleting Management Zone${NC}"
    RESPONSE=$(curl -X DELETE -H  "accept: */*" -H  "Authorization: Api-Token $DT_CONFIG_TOKEN" "$DT_API_URL/api/config/v1/managementZones/$MG_ID_HIPSTERSHOP");
    echo -e "${YLW}$RESPONSE${NC}"
fi

if [ ! -z "$MG_ID_INFRA" ]
then
    echo -e "${YLW}Deleting Management Zone${NC}"
    RESPONSE=$(curl -X DELETE -H  "accept: */*" -H  "Authorization: Api-Token $DT_CONFIG_TOKEN" "$DT_API_URL/api/config/v1/managementZones/$MG_ID_INFRA");
    echo -e "${YLW}$RESPONSE${NC}"
fi
