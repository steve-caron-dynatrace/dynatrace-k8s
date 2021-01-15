#!/bin/bash

cd istio-1.7.0

export PATH=$PWD/bin:$PATH

kubectl delete -f samples/addons
istioctl manifest generate --set profile=demo | kubectl delete --ignore-not-found=true -f -
kubectl delete namespace istio-system


