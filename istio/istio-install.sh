#!/bin/bash

## downloading istioctl
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.7

cd istio-1.7.0

cp values.yaml ./manifests/charts/gateways/istio-ingress/values.yaml

export PATH=$PWD/bin:$PATH

istioctl install --set profile=demo --manifests ./manifests


