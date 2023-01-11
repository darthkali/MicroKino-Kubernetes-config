kind delete cluster --name micro-kino-cluster-ingress-route

# create cluster
kind create cluster --config kind-cluster.yml


# Install Traefik Resource Definitions:
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.9/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml

# Install RBAC for Traefik:
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.9/docs/content/reference/dynamic-configuration/kubernetes-crd-rbac.yml


helm repo add traefik https://traefik.github.io/charts
helm repo update
helm install traefik traefik/traefik

kubectl apply -f dashboard.yaml
kubectl apply -f resources.yaml

## create traefik
#https://medium.com/kubernetes-tutorials/deploying-traefik-as-ingress-controller-for-your-kubernetes-cluster-b03a0672ae0c
#kubectl apply -f stack/
#kubectl apply -f traefik.yml
#kubectl apply -f ingress-route.yaml
#kubectl apply -f wahomi.yaml
#
#kubectl get all

#
#kubectl create -f traefik/traefik-rbac.yaml \
#  -f traefik/traefik-deployment.yaml \
#  -f traefik/traefik-ingress.yaml
#
#helm repo add traefik https://traefik.github.io/charts
#helm repo update
#helm install --values traefik/values.yml traefik/traefik --generate-name


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
