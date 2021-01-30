#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

CURRENT_DIR=$(pwd)

## Deploy Istio

cd $CURRENT_DIR/istio
/bin/bash ./istio-install.sh

## Deploy the OneAgent Operator

cd $CURRENT_DIR/dynatrace/kubernetes
./deploy-operator.sh

## Deploy ActiveGate
#./deploy-activegate.sh

## Deploy Kubernetes ActiveGate
./deploy-k8s-activegate.sh

## Configure Dynatrace-Kubernetes integration
./config-k8s-integration.sh

## Configure Maintenance Window to silence kube-proxy tcp connectivity problem
cd $CURRENT_DIR/dynatrace/kubernetes/kube-proxy
./create-kube-proxy-maintenance-window.sh

## Configure Anomaly Detection Rules
cd $CURRENT_DIR/dynatrace/alerting
./create-anomaly-detection-rules.sh

## Deploy EasyTravel app
cd $CURRENT_DIR/easytravel/scripts
./create_easytravel.sh
./get-easytravel-urls.sh

## Configure Dynatrace for EasyTravel
cd $CURRENT_DIR/easytravel/dynatrace
./config-dt-webapps.sh

## Deploy Sock Shop app
cd $CURRENT_DIR/sockshop/scripts
./deploy-sockshop.sh -istio
./get-sockshop-urls.sh -istio
./create-sockshop-accounts.sh

## Configure Dynatrace for Sock Shop
cd $CURRENT_DIR/sockshop/dynatrace
./config-dt-webapps-synth.sh -istio

## Create dashboards
cd $CURRENT_DIR/dynatrace/dashboards/create-dashboards.sh