kind delete cluster --name micro-kino-cluster

# create cluster
kind create cluster --config kind-cluster.yml

## create traefik
#https://medium.com/kubernetes-tutorials/deploying-traefik-as-ingress-controller-for-your-kubernetes-cluster-b03a0672ae0c
kubectl create -f traefik/traefik-rbac.yaml \
  -f traefik/traefik-deployment.yaml \
  -f traefik/traefik-ingress.yaml

helm repo add traefik https://traefik.github.io/charts
helm repo update
helm install --values traefik/values.yml traefik/traefik

# \
### create postgres
#kubectl apply -f postgres/postgres-deployment.yml \
#              -f postgres/postgres-service.yml
#
### create secrets
#kubectl apply -f dockerconfigjson.yml
#
### create service
#kubectl apply -f deployment.yml \
#              -f service.yml
#
#
#echo "Set Port Forwarding with specific service name. Have a look into the Shell Script for more details."
## find name with the following command:
#echo $(kubectl get pods -l app=cinema-service -o custom-columns=:metadata.name)

## port-forward
#kubectl port-forward cinema-service-78d55fd998-hftcd -n default 8090:8090
