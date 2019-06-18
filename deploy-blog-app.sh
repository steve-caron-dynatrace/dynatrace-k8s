#!/bin/bash
kubectl create namespace blog-app
kubectl create secret generic mysql-pass --from-literal=password=hot2019 -n blog-app
kubectl apply -f blog-app/
