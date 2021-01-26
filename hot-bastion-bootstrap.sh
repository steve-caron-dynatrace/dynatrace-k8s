#!/bin/bash

##############
## This script is specific to the Perform 2021 HOT class DT_ENVIRONMENT_ID
##############

YLW='\033[1;33m'
NC='\033[0m'

if [ -z "$DYNATRACE_ENVIRONMENT_ID" ]; then
    echo -e "${YLW}DYNATRACE_ENVIRONMENT_ID variable is not defined or accessible... exiting${NC}"
    exit  
else
    if [ -z "$DYNATRACE_TOKEN" ]; then
        echo -e "${YLW}DYNATRACE_TOKEN variable is not defined or accessible... exiting${NC}"
    fi
fi

DTU_TRAINING_HOME=/home/dtu_training

git clone https://github.com/steve-caron-dynatrace/dynatrace-k8s.git /home/dtu_training/dynatrace-k8s
cd /home/dtu_training/dynatrace-k8s
sed -i -r 's~DT_ENVIRONMENT_ID=(.*)~DT_ENVIRONMENT_ID\='"$DYNATRACE_ENVIRONMENT_ID"'~' ./configuration.conf
sed -i -r 's~DT_API_TOKEN=(.*)~DT_API_TOKEN\='"$DYNATRACE_TOKEN"'~' ./configuration.conf
sed -i -r 's~DT_PAAS_TOKEN=(.*)~DT_PAAS_TOKEN\='"$DYNATRACE_TOKEN"'~' ./configuration.conf
sed -i -r 's~DT_CONFIG_TOKEN=(.*)~DT_CONFIG_TOKEN\='"$DYNATRACE_TOKEN"'~' ./configuration.conf

CURRENT_DIR=$(pwd)

## Execute the generic setup script
./setup.sh
