kind delete cluster --name micro-kino

# create cluster
kind create cluster --config kind-cluster.yml

## create secrets
kubectl apply -f dockerconfigjson.yml

# create postgres
kubectl apply -f postgres

# create kafka
kubectl apply -f kafka

# create cinema-service
kubectl apply -f cinemaservice
kubectl apply -f bookingservice
kubectl apply -f movieservice
kubectl apply -f showservice

# create traefik & ingressroute
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.9/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml #Traefik Resource Definitions::
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.9/docs/content/reference/dynamic-configuration/kubernetes-crd-rbac.yml          #RBAC for Traefik
kubectl apply -f traefik

echo "Set Port Forwarding after all pods are up and running. \n Run the following command in a new terminal: \n kubectl port-forward --address 0.0.0.0 service/traefik 8000:8000 8080:8080 443:4443 -n default"
# check pod status
kubectl get pods -w
#kubectl port-forward --address 0.0.0.0 service/traefik 8000:8000 8080:8080 443:4443 -n default
