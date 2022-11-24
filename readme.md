# OCP  sandbox
[Home Page](https://developers.redhat.com/developer-sandbox)

[oc download](https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/)


```bash

wget https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz
sudo tar -xvzf oc.tar.gz  
sudo chmod +x  oc  kubectl 
sudo mv oc /usr/local/bin/oc
sudo mv kubectl /usr/local/bin/kubectl
sudo usermod -aG docker $USER

sudo curl -L https://mirror.openshift.com/pub/openshift-v4/clients/odo/latest/odo-linux-amd64 -o /usr/local/bin/odo
sudo chmod +x /usr/local/bin/odo

oc login --token=sha256~5XQJvUxMOcSrEBBVYl6ai7WH6SxjJMvte4C0ig7VD8w --server=https://api.sandbox.x8i5.p1.openshiftapps.com:6443

export cluster_name=api-sandbox-x8i5-p1-openshiftapps-com:6443
export token=sha256~5XQJvUxMOcSrEBBVYl6ai7WH6SxjJMvte4C0ig7VD8w
export username=robert0714-lee
export api_server_url=https://api.sandbox.x8i5.p1.openshiftapps.com:6443

kubectl config set-credentials $username/$cluster_name --token=$token
kubectl config set-cluster $cluster_name --server=$api_server_url

export context=$username-dev/$cluster_name/$username

kubectl config set-context $context --user=$username/$cluster_name   --namespace=$username-dev --cluster=$cluster_name

```

### Exposing the registry 
https://docs.openshift.com/container-platform/4.7/registry/securing-exposing-registry.html

You must administrator


1. Set DefaultRoute to True:

```bash
$ oc patch configs.imageregistry.operator.openshift.io/cluster --patch '{"spec":{"defaultRoute":true}}' --type=merge
```
2. Log in with podman:

```bash
$ HOST=$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')

$ podman login -u kubeadmin -p $(oc whoami -t) --tls-verify=false $HOST 
```
--tls-verify=false is needed if the cluster’s default certificate for routes is untrusted. You can set a custom, trusted certificate as the default certificate with the Ingress Operator.


3. about azureDevOps pipeline:

```yml
   # A script task making use of 'oc'
  - script: |      
      echo --------------------------------------------------------------------------------------------
      HOST=$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')
      podman login -u kubeadmin -p $(oc whoami -t) --tls-verify=false $HOST
      podman  images
      podman push $HOST/ito-pdc/tmf622:$(Build.BuildNumber)  --tls-verify=false
    displayName: 'transport container image:$(Build.BuildNumber)  '
```
#### Minikube can use the exposed the registry 
If the route of openshift-image-registry  is **https://default-route-openshift-image-registry.apps.ocp.iisi.test/** .
in wondows
```shell
eval $(minikube dokcer-env)
winpty docker login default-route-openshift-image-registry.apps.ocp.iisi.test
(username is admin)
(password is the token: sha256~5XQJvUxMOcSrEBBVYl6ai7WH6SxjJMvte4C0ig7VD8w )

docker image pull default-route-openshift-image-registry.apps.ocp.iisi.test/[namespace]/[image]:[tag]
```

### Image Scheche import ? right now import ?
```
oc -n ito-pdc import-image chttmf622.azurecr.io/tmf622:latest --from="chttmf622.azurecr.io/tmf622:latest" --confirm --reference-policy=local
```
https://itnext.io/variations-on-imagestreams-in-openshift-4-f8ee5e8be633

new tag

```bash
oc tag image-registry.openshift-image-registry.svc:5000/robert0714-lee-dev/tmf622:latest  robert0714-lee-dev/tmf622:20210730.11
```
https://cloudowski.com/articles/why-managing-container-images-on-openshift-is-better-than-on-kubernetes/

### Where can I find the sha256 code of a docker image?

```bash
docker inspect --format='{{index .RepoDigests 0}}' $IMAGE
docker inspect --format='{{.RepoDigests}}' $IMAGE
docker images --digests
docker images --no-trunc --quiet $IMAGE
docker images --no-trunc --quiet debian:stretch-slim
```
### NFS Storage Class
Take example about sysage. [https://github.com/kubernetes-retired/external-storage/tree/master/nfs-client]
namespace: nfs-provisioner
nfs-client-provisioner

```yml
kind: Deployment
apiVersion: apps/v1
metadata:  
  name: nfs-client-provisioner  
  namespace: nfs-provisioner
  labels:
    app: nfs-client-provisioner
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nfs-client-provisioner
  template:
    metadata:
      labels:
        app: nfs-client-provisioner
    spec:
      restartPolicy: Always
      serviceAccountName: nfs-client-provisioner
      containers:
        - name: nfs-client-provisioner
          image: 'quay.io/external_storage/nfs-client-provisioner:latest'
          env:
            - name: PROVISIONER_NAME
              value: fuseim.pri/ifs
            - name: NFS_SERVER
              value: 10.9.44.151
            - name: NFS_PATH
              value: /data
          volumeMounts:
            - name: nfs-client-root
              mountPath: /persistentvolumes
          terminationMessagePath: /dev/termination-log
          terminationMessagePolicy: File
          imagePullPolicy: Always
      serviceAccount: nfs-client-provisioner
      volumes:
        - name: nfs-client-root
          nfs:
            server: 10.9.44.151
            path: /data
```
StorageClass.ymal

```yml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: managed-nfs-storage
provisioner: fuseim.pri/ifs # or choose another name, must match deployment's env PROVISIONER_NAME'
parameters:
  archiveOnDelete: "false"
```
rbac.yaml

```yml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: nfs-client-provisioner
  # replace with namespace where provisioner is deployed
  namespace: default
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: nfs-client-provisioner-runner
rules:
  - apiGroups: [""]
    resources: ["persistentvolumes"]
    verbs: ["get", "list", "watch", "create", "delete"]
  - apiGroups: [""]
    resources: ["persistentvolumeclaims"]
    verbs: ["get", "list", "watch", "update"]
  - apiGroups: ["storage.k8s.io"]
    resources: ["storageclasses"]
    verbs: ["get", "list", "watch"]
  - apiGroups: [""]
    resources: ["events"]
    verbs: ["create", "update", "patch"]
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: run-nfs-client-provisioner
subjects:
  - kind: ServiceAccount
    name: nfs-client-provisioner
    # replace with namespace where provisioner is deployed
    namespace: default
roleRef:
  kind: ClusterRole
  name: nfs-client-provisioner-runner
  apiGroup: rbac.authorization.k8s.io
---
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: leader-locking-nfs-client-provisioner
  # replace with namespace where provisioner is deployed
  namespace: default
rules:
  - apiGroups: [""]
    resources: ["endpoints"]
    verbs: ["get", "list", "watch", "create", "update", "patch"]
---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: leader-locking-nfs-client-provisioner
  # replace with namespace where provisioner is deployed
  namespace: default
subjects:
  - kind: ServiceAccount
    name: nfs-client-provisioner
    # replace with namespace where provisioner is deployed
    namespace: default
roleRef:
  kind: Role
  name: leader-locking-nfs-client-provisioner
  apiGroup: rbac.authorization.k8s.io
```
### With Helm
https://docs.openshift.com/container-platform/4.7/cli_reference/helm_cli/getting-started-with-helm-on-openshift-container-platform.html




```bash
$ helm install stable/nfs-client-provisioner --set nfs.server=x.x.x.x --set nfs.path=/exported/path
```


## Tutorials
[examples](https://developers.redhat.com/developer-sandbox/activities)

### Homework 01: Learn Kubernetes using the Developer Sandbox for Red Hat OpenShift
https://developers.redhat.com/developer-sandbox/activities/learn-kubernetes-using-red-hat-developer-sandbox-openshift



```bash
git clone https://github.com/donschenck/quotesweb
git clone https://github.com/donschenck/quotemysql
git clone https://github.com/donschenck/qotd-python

curl http://quotes-robert0714-lee-dev.apps.sandbox.x8i5.p1.openshiftapps.com/version
curl http://quotes-robert0714-lee-dev.apps.sandbox.x8i5.p1.openshiftapps.com/writtenin
curl http://quotes-robert0714-lee-dev.apps.sandbox.x8i5.p1.openshiftapps.com/quotes
curl http://quotes-robert0714-lee-dev.apps.sandbox.x8i5.p1.openshiftapps.com/quotes/random
```

To do this, move into your "quotesweb/src/components" directory and change the file "quotes.js". Substitute your URL in the following line of code (it's line 26):
```javascript
fetch('your-url-goes-here')
```
Save this change.

Move back into your "quotesweb" directory where the file "Dockerfile" is located, and build your image. You will need to use your own naming pattern based on your own image registry. Here's an example from an imaginary registry:
```bash
docker build -t quay.io/robert0714/quotesweb:v1 .
```
With the image built, push it to your image registry. For example:

```bash
docker push quay.io/robert0714/quotesweb:v1
```

The name of the image we create (e.g. "quay.io/johndoe/quotest:v1") will be used when we alter the deployment file, "quote-deployment.yaml". Find and change the following line, replacing the image name with your own image.

```
image: quay.io/robert0714/quotesweb:v1
```

### Homework 02:  Deploy a Java application on Kubernetes in minutes
https://developers.redhat.com/developer-sandbox/activities/how-to-deploy-java-application-in-kubernetes

https://www.youtube.com/watch?v=oPLQs-lAAYk

https://github.com/redhat-developer-demos/spring-petclinic


# Developer CLI (odo)
https://docs.openshift.com/container-platform/4.7/cli_reference/developer_cli_odo/creating_and_deploying_applications_with_odo/creating-an-application-with-a-database.html

# Services Access Using Name

```
http://service-name.namespace.svc.cluster.local:port-number
```

# AutoScaleing Test
minikube preparation 
```bash
minikube -p a01  start --memory=10240 --cpus=4 --disk-size=30g 
minikube -p a01  addons enable ingress
minikube -p a01  addons enable metrics-server
```
add loadbalancer
```bash
minikube -p a01 kubectl -- label node a01  proxy=true


git clone https://github.com/robert0714/keepalived.git 
cd keepalived && git  checkout k8s-1.16  && cd ..

minikube -p a01 kubectl -- create namespace keepalived

helm install keepalived  keepalived \
   --namespace keepalived \
   --set keepalivedCloudProvider.serviceIPRange="$( minikube -p a01 ip)/24" \
   --set nameOverride="lb"

helm  -n keepalived list

minikube -p a01 kubectl get svc
```
