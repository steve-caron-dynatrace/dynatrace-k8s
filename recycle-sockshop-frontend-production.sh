#!/bin/bash

kubectl scale --replicas=0 --current-replicas=1 deployments -l tier=frontend -n production

sleep (5000)

kubectl get deployments -n production

kubectl scale --replicas=1 --current-replicas=0 deployments -l tier=frontend -n production

sleep (5000)

kubectl get deployments -n production
