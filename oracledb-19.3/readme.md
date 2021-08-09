
https://pittar.medium.com/running-oracle-12c-on-openshift-container-platform-ca471a9f7057

```bash
$ oc login -u system:admin
$ oc project oracle-test
$ oc create sa oracle
```
*  A new Project (namespace in Kubernetes terms) called “oracle-test”
*  A service account called “oracle” with elevated privileges to run Oracle.

Create a file called “anyuid-role.yaml” with the following contents:
```yaml
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: Role
metadata:
  name: oracle-anyuid-role
rules:
  - apiGroups:
    - security.openshift.io
    resourceNames:
      - anyuid
    resources:
      - securitycontextconstraints
    verbs:
      - use
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: RoleBinding
metadata:
  name: oracle-anyuid-rolebinding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: oracle-anyuid-role
subjects:
  - kind: ServiceAccount
    name: oracle
```

```bash
$ oc process -f oracle19c-template.yaml | oc create -f -
$ oc process -f oracle19c-template.yaml | oc delete -f -
```
log as pod
```bash
sh-4.2$ source /home/oracle/.bashrc
[oracle@oracle19c-1-hzsl5 ~]$  sqlplus system/oracle@ORCL
```