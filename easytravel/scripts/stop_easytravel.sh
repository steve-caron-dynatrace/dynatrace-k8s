kubectl -n easytravel scale --replicas=0 deployment/easytravel-backend
kubectl -n easytravel scale --replicas=0 deployment/easytravel-frontend
kubectl -n easytravel scale --replicas=0 deployment/easytravel-mongodb
kubectl -n easytravel scale --replicas=0 deployment/easytravel-www
kubectl -n easytravel scale --replicas=0 deployment/loadgen

