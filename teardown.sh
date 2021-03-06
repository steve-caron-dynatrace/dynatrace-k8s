#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

CURRENT_DIR=$(pwd)

## Uninstall Istio

cd $CURRENT_DIR/istio
./istio-uninstall.sh

## Uninstall the Dynatrace Operator

cd $CURRENT_DIR/dynatrace/kubernetes
./uninstall-operator.sh

## Delete Maintenance Window
cd $CURRENT_DIR/dynatrace/kubernetes/kube-proxy
./delete-kube-proxy-maintenance-window.sh

## Delete EasyTravel app
cd $CURRENT_DIR/easytravel/scripts
./delete_easytravel.sh

## Remove Dynatrace configuration for EasyTravel
cd $CURRENT_DIR/easytravel/dynatrace
./delete-dt-webapps-configs.sh

## Delete Sock Shop app
cd $CURRENT_DIR/sockshop/scripts
./delete-sockshop.sh

## Remove Dynatrace configuration for Sock Shop
cd $CURRENT_DIR/sockshop/dynatrace
./delete-dt-webapps-synth-configs.sh

## Remove HipsterShop app
cd $CURRENT_DIR/hipstershop
./teardown.sh

## Delete dashboard
cd $CURRENT_DIR/dynatrace/dashboards
./delete-dashboards.sh

## Delete anomaly detection rules
cd $CURRENT_DIR/dynatrace/alerting
./delete-anomaly-detection-rules.sh

## Delete alerting profiles
cd $CURRENT_DIR/dynatrace/alerting
./delete-alerting-profiles.sh

## Delete management zones
cd $CURRENT_DIR/dynatrace/management-zones
./delete-management-zones.sh
