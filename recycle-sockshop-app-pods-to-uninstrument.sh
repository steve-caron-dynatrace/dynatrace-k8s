#!/bin/bash


kubectl patch -n dev deployment carts -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch -n dev deployment catalogue -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch -n dev deployment front-end -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch -n dev deployment orders -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch -n dev deployment payment -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch -n dev deployment queue-master -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch -n dev deployment rabbitmq -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch -n dev deployment shipping  -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch -n dev deployment user -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'


kubectl patch deployment -n production carts -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch deployment -n production catalogue -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch deployment -n production front-end -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch deployment -n production orders -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch deployment -n production payment -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch deployment -n production queue-master -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch deployment -n production rabbitmq -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch deployment -n production shipping  -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'
kubectl patch deployment -n production user -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace/instrument": "false"}}}}}'

sleep 20s
kubectl get po --all-namespaces -l product=sockshop
