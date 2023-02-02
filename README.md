# MicroKino-Kubernetes-config

The Kubernetes config repository for the corresponding MicroKino Microservices
https://github.com/fh-erfurt/MicroKino

## Hinweis
Unter Verwendung von Linux muss ggf. mit `sudo` die Berechitung erteilt werden.

## Einmaliges Setup

Dies folgenden Schritte müssen nur einmalig durchgeführt werden und sind ggf schon auf eurem System vorhanden.

### Package-Managers:
**Mac**
- [Homebrew](https://brew.sh/)

**Windows**
- [Chocolatey](https://chocolatey.org/)


### Kind

**Mac**
``` shell
brew install kind
```
**Windows**
``` shell
choco install kind
```

**Linux**
``` shell
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.17.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

### Kubectl
**Mac**
https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/
``` shell
brew install kubectl
```

**Windows**
https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/
``` shell
choco install kubernetes-cli
```

**Linux**
https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
``` shell
sudo snap install kubectl --classic
```

### Docker
**Mac**
https://docs.docker.com/docker-for-mac/install/
``` shell
brew install docker
```

**Windows**
https://docs.docker.com/docker-for-windows/install/
``` shell
choco install docker-desktop
```

**Linux**
Für Linux sind mehrere Schritte nötig, diese sind auf der Docker-Website beschrieben:
https://docs.docker.com/engine/install/ubuntu/


### Erzeuge Personal Access Token (PAT) auf GitHub
- Einstellungen -> Developer Settings -> Personal Access Tokens -> Generate new token
- read:packages

### Secrets erstellen
https://dev.to/asizikov/using-github-container-registry-with-kubernetes-38fb

#### 1. base64 encode PAT

``` shell
echo -n "<github-username>:<personal-access-token" | base64
```
> output = base-64-encoded-pat

```shell
echo -n  '{"auths":{"ghcr.io":{"auth":"<base-64-encoded-pat>"}}}' | base64
```
> output = base-64-encoded-docker-config
#### 2. Secret zu kubernetes hinzufügen

Generate `dockerconfigjson.yaml` file if not exists and add the base64 encoded PAT to the field `data.dockerconfigjson`

``` yaml
kind: Secret
type: kubernetes.io/dockerconfigjson
apiVersion: v1
metadata:
  name: dockerconfigjson-github-com
  labels:
    app: app-name
data:
  .dockerconfigjson: <base-64-encoded-docker-config>
```

### Login in Github Container Registry
``` shell
docker login ghcr.io -u <github-username> -p <personal-access-token>
```

### Server Adresse anpassen
In der Datei `traefik/ingressroutes.yaml` muss die Serveradresse angepasst werden:

Für jede Route muss die Serveradresse angepasst werden. Diese muss mit der Adresse des Servers übereinstimmen, auf dem die Microservices laufen.  Dies kann euer Server sein oder wenn ihr es Lokal ausführt, dann ist es `localhost`.
```yaml
- match: Host(`<server-adresse>`) && PathPrefix(`/cinema`)
#z.B.:
- match: Host(`localhost`) && PathPrefix(`/cinema`)
- match: Host(`microkino.ai.fh-erfurt.de`) && PathPrefix(`/cinema`)
```

## Starten des Clusters
dem deploy.sh Script im root Ordner passende Rechte geben (muss nur einmalig gemacht werden)
``` shell
chmod +x deploy.sh
```

Starten des Kubernetes Clusters über die Konfigurationsdatei (deploy.sh)
``` shell
./deploy.sh
```

Wenn alle Pods laufen, dann muss noch das PortForwarding eingerichtet werden:
```shell
sudo kubectl port-forward --address 0.0.0.0 service/traefik 80:80 8080:8080 443:4443 -n default
```

### Endpoints
- http://microkino.ai.fh-erfurt.de/cinema/cinemas
- http://microkino.ai.fh-erfurt.de/booking/creditCards
- ...

---
## Zusätzliche Kommandos
### Create Cluster
Mit Standardnamen `kind`

``` shell
kind create cluster
```

Mit benutzerdefinierten Namen `microkino-cluster`

``` shell
kind create cluster --name microkino-cluster
```
Mit Konfigdatei

Config File `kind-config.yaml`

``` yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: micro-kino-cluster
nodes:
  - role: control-plane
```

``` shell
kind create cluster --config kind-config.yaml
```

### Kind Cluster anzeigen

``` shell
kind get clusters
```

### Nodes anzeigen

``` shell
kubectl get nodes
```

### Cluster Löschen

``` shell
kind delete cluster --name microkino-cluster
```

## Nächste Schritte
- Workflow für automatisiertes Deployment neuer Versionen inkl. Test
- Unzuverlässigkeit vom Kafka-Dienst beheben
- Tracing + Metrics
