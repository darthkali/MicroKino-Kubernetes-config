kind delete cluster --name micro-kino-cluster-ingress-route

# create cluster
kind create cluster --config kind-cluster.yml
# Install Traefik Resource Definitions:
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.9/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml

# Install RBAC for Traefik:
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.9/docs/content/reference/dynamic-configuration/kubernetes-crd-rbac.yml
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.9/docs/content/user-guides/crd-acme/02-services.yml
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.9/docs/content/user-guides/crd-acme/03-deployments.yml
kubectl port-forward --address 0.0.0.0 service/traefik 8000:8000 8080:8080 443:4443 -n default
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.9/docs/content/user-guides/crd-acme/04-ingressroutes.yml