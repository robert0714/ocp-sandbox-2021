```bash
oc login --token=sha256~VxO7nwAP3ZQ8QVyYu3NQj5bOlpc_0oHwR6LVGzom-uQ --server=https://api.ocp.iisi.test:6443
HOST=$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')
podman login -u kubeadmin -p $(oc whoami -t) --tls-verify=false $HOST
podman  build -t  $HOST/loggging/fluendt:v1   .
podman push  $HOST/loggging/fluendt:v1    --tls-verify=false
```