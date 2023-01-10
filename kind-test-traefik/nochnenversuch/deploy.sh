kind delete cluster --name micro-kino-cluster-ingress-route

# create cluster
kind create cluster --config kind-cluster.yml


#####
## create postgres
kubectl apply -f kind-test-one-service/postgres/postgres-deployment.yml
kubectl apply -f kind-test-one-service/postgres/postgres-service.yml

## create secrets
kubectl apply -f kind-test-one-service/dockerconfigjson.yml

## create service
kubectl apply -f kind-test-one-service/deployment.yml
kubectl apply -f kind-test-one-service/service.yml

#####
# Install Traefik Resource Definitions:
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.9/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml

# Install RBAC for Traefik:
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.9/docs/content/reference/dynamic-configuration/kubernetes-crd-rbac.yml


kubectl apply -f services.yml
kubectl apply -f deployments.yml
kubectl apply -f ingressroutes.yml
#sleep 20
kubectl port-forward --address 0.0.0.0 service/traefik 8000:8000 8080:8080 443:4443 -n default
