#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

CURRENT_DIR=$(pwd)

## Deploy Istio

cd $CURRENT_DIR/istio
/bin/bash ./istio-install.sh

## Deploy the OneAgent Operator

cd $CURRENT_DIR/dynatrace/kubernetes
./deploy_operator.sh

## Deploy ActiveGate
./deploy-activegate.sh

## Configure Dynatrace-Kubernetes integration
./config-k8s-integration.sh

## Deploy EasyTravel app
cd $CURRENT_DIR/easytravel/scripts
./create_easytravel.sh
./get-easytravel-urls.sh

## Deploy Sock Shop app
cd $CURRENT_DIR/sockshop/scripts
./deploy-sockshop.sh -istio
./get-sockshop-urls.sh -istio
./create-sockshop-accounts.sh

## Configure Dynatrace for Sock Shop
cd $CURRENT_DIR/sockshop/dynatrace
./config-dt-webapps-synth.sh -istio

