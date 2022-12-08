# MicroKino-Kubernetes-config

The Kubernetes config repository for the corresponding MicroKino Microservices
https://github.com/fh-erfurt/MicroKino

## Kind

### Installation

### Kind

**Mac**

``` shell
brew nstall kind
```

**Windows**

``` shell
choco install kind
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

### Create Cluster

With default name `kind`

``` shell
kind create cluster
```

With custom name `microkino-cluster`

``` shell
kind create cluster --name microkino-cluster
```

get kind clusters

``` shell
kind get clusters
```

get nodes

``` shell
kubectl get nodes
```

#### create Cluster with config

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


### Delete Cluster

``` shell
kind delete cluster --name microkino-cluster
```

### Secrets
https://dev.to/asizikov/using-github-container-registry-with-kubernetes-38fb

#### 1. generate Personal Access Token (PAT) on GitHub
- read:packages

#### 2. base64 encode PAT

``` shell
echo -n "<github-username>:<personal-access-token" | base64
```
> output = base-64-encoded-pat

```shell
echo -n  '{"auths":{"ghcr.io":{"auth":"<base-64-encoded-pat>"}}}' | base64
```
> output = base-64-encoded-docker-config
#### 3. Add secret to kubernetes
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

