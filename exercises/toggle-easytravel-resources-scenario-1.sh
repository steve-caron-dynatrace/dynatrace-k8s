#!/bin/bash
  
YLW='\033[1;33m'
NC='\033[0m'

read -p "Do you want to enable (1) or disable (2) EasyTravel resource usage scenario? Enter 1 or 2 : " -n 1 -r
echo ""

if [[ $REPLY =~ ^[12]$ ]]
then
    if [[ $REPLY =~ ^1$ ]]
    then
            ENABLE=true
    else
            ENABLE=false
    fi
    EASYTRAVEL_URL=$(grep "EASYTRAVEL_URL=" ../configuration.conf | sed 's~EASYTRAVEL_URL=[ \t]*~~')
    echo $(curl "$EASYTRAVEL_URL:8080/services/ConfigurationService/registerPlugins?pluginData=CPULoad")
    echo $(curl "$EASYTRAVEL_URL:8080/services/ConfigurationService/setPluginEnabled?name=CPULoad&enabled=$ENABLE")
else
echo ""
echo -e "${YLW}You did not enter a valid option (1 or 2). Nothing will happen."
fi