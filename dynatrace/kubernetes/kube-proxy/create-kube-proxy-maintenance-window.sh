#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

PG_DETECTED_NAME="kube-proxy kube-proxy"

TENANT_ID=$(grep "DT_ENVIRONMENT_ID=" ../../../configuration.conf | sed 's~DT_ENVIRONMENT_ID=[ \t]*~~')
DT_API_URL="https://$TENANT_ID.sprint.dynatracelabs.com"
DT_CONFIG_TOKEN=$(grep "DT_CONFIG_TOKEN=" ../../../configuration.conf | sed 's~DT_CONFIG_TOKEN=[ \t]*~~')
DT_API_TOKEN=$(grep "DT_API_TOKEN=" ../../../configuration.conf | sed 's~DT_API_TOKEN=[ \t]*~~')

PROCESS_GROUPS=$(curl  -X GET "$DT_API_URL/api/v1/entity/infrastructure/process-groups?relativeTime=30mins&includeDetails=true" -H  "accept: application/json; charset=utf-8" -H  "Authorization: Api-Token $DT_API_TOKEN")

PG_ID=$(echo "$PROCESS_GROUPS" | jq -c -r '.[] | select(.discoveredName == "kube-proxy kube-proxy") | .entityId')

if [ ! -z "$PG_ID" ]
then
    echo -e "${YLW}Configuring Maintenance Window${NC}"
    MAINTENANCE_WINDOW=$(cat ./maintenance-window-template.json | sed "s/<PG_ID>/$PG_ID/")
    RESPONSE=$(curl -X POST "$DT_API_URL/api/config/v1/maintenanceWindows" -H "accept: application/json; charset=utf-8" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -H "Content-Type: application/json; charset=utf-8" -d "$MAINTENANCE_WINDOW")
    echo -e "${YLW}$RESPONSE${NC}"
else
    echo -e "${YLW}Error - PG $PG_DETECTED_NAME was not found in Dynatrace.${NC}"
fi