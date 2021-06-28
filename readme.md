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

oc login --token=sha256~Ma2K1jVjyKqIdV2OMHDk36ysKWXEaC0wCqFHJqDfoiA --server=https://api.sandbox.x8i5.p1.openshiftapps.com:6443

export cluster_name=api-sandbox-x8i5-p1-openshiftapps-com:6443
export token=sha256~Ma2K1jVjyKqIdV2OMHDk36ysKWXEaC0wCqFHJqDfoiA
export username=robert0714-lee
export api_server_url=https://api.sandbox.x8i5.p1.openshiftapps.com:6443

kubectl config set-credentials $username/$cluster_name --token=$token
kubectl config set-cluster $cluster_name --server=$api_server_url

export context=$username-dev/$cluster_name/$username

kubectl config set-context $context --user=$username/$cluster_name   --namespace=$username-dev --cluster=$cluster_name

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

