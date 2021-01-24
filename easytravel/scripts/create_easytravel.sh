#!/bin/sh

#!./setup_base.sh
echo "Setting up easyTravel"
kubectl create namespace easytravel
#kubectl apply -f ../compute-resources-quota.yaml

#!./create.sh
echo "Creating easyTravel"
kubectl create -f ../manifests/easytravel-mongodb-deployment.yaml
kubectl create -f ../manifests/easytravel-mongodb-service.yaml
kubectl create -f ../manifests/easytravel-backend-deployment.yaml
kubectl create -f ../manifests/easytravel-frontend-deployment.yaml
kubectl create -f ../manifests/easytravel-nginx-deployment.yaml
kubectl create -f ../manifests/easytravel-pluginservice-deployment.yaml
kubectl create -f ../manifests/easytravel-pluginservice-service.yaml

echo "Exposing easyTravel"
kubectl create -f ../manifests/easytravel-backend-service.yaml
kubectl create -f ../manifests/easytravel-frontend-service.yaml
kubectl create -f ../manifests/easytravel-nginx-service.yaml
echo "Waiting for 150 seconds before starting loadgen"
sleep 150
kubectl create -f ../manifests/easytravel-loadgen-deployment.yaml
