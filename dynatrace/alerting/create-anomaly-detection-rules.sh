#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

DT_API_URL=$(grep "DT_API_URL=" ../../configuration.conf | sed 's~DT_API_URL=[ \t]*~~')

DT_CONFIG_TOKEN=$(grep "DT_CONFIG_TOKEN=" ../../configuration.conf | sed 's~DT_CONFIG_TOKEN=[ \t]*~~')

echo -e "${YLW}Creating anomaly detection rules${NC}"

RESPONSE=$(curl -X POST "$DT_API_URL/api/config/v1/anomalyDetection/metricEvents" -H "accept: application/json; charset=utf-8" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -H "Content-Type: application/json; charset=utf-8" -d @./oomkill-custom-event.json)
echo -e "${YLW}$RESPONSE${NC}"

RESPONSE=$(curl -X POST "$DT_API_URL/api/config/v1/anomalyDetection/metricEvents" -H "accept: application/json; charset=utf-8" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -H "Content-Type: application/json; charset=utf-8" -d @./pending-pods-custom-event.json)
echo -e "${YLW}$RESPONSE${NC}"

RESPONSE=$(curl -X POST "$DT_API_URL/api/config/v1/anomalyDetection/metricEvents" -H "accept: application/json; charset=utf-8" -H "Authorization: Api-Token $DT_CONFIG_TOKEN" -H "Content-Type: application/json; charset=utf-8" -d @./cpu-throttle-custom-event.json)
echo -e "${YLW}$RESPONSE${NC}"
