#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

echo -e "${YLW}Uninstalling Dynatrace ActiveGate...${NC}"
echo ""

sudo /opt/dynatrace/gateway/uninstall.sh
sudo rm -rf /opt/dynatrace/gateway

