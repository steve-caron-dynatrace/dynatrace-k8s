#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

DT_API_URL=$(grep "DT_API_URL=" ../../../configuration.conf | sed 's~DT_API_URL=[ \t]*~~')

DT_CONFIG_TOKEN=$(grep "DT_CONFIG_TOKEN=" ../../../configuration.conf | sed 's~DT_CONFIG_TOKEN=[ \t]*~~')


MAINTENANCE_GROUPS=$(curl  -X GET "$DT_API_URL/api/config/v1/maintenanceWindows" -H  "accept: application/json; charset=utf-8" -H  "Authorization: Api-Token $DT_CONFIG_TOKEN")

MAINTENANCE_WINDOW_ID=$(echo $MAINTENANCE_GROUPS | jq -c -r '.values | .[] | select(.name == "dynatrace-workshop") | .id')

if [ ! -z "$MAINTENANCE_WINDOW_ID" ]
then
    RESPONSE=$(curl -X DELETE -H  "accept: */*" -H  "Authorization: Api-Token $DT_CONFIG_TOKEN" "$DT_API_URL/api/config/v1/maintenanceWindows/$MAINTENANCE_WINDOW_ID");
    echo -e "${YLW}$RESPONSE${NC}"
fi