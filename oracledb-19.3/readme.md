# Requirement
RAM 4G +

## init configuration
1.   username: system 
2.   password: oracle

```bash
docker exec -it  xe19c  sqlplus system/oracle@ORCL
SQL> show con_name;
alter session set container=CDB$ROOT;
CREATE USER c##RAADM_OWNER IDENTIFIED BY "oracle" DEFAULT TABLESPACE USERS TEMPORARY TABLESPACE TEMP;
grant create session, grant any privilege to c##RAADM_OWNER;
GRANT UNLIMITED TABLESPACE TO  c##RAADM_OWNER;
GRANT CREATE ANY SEQUENCE, ALTER ANY SEQUENCE, DROP ANY SEQUENCE, SELECT ANY SEQUENCE TO  c##RAADM_OWNER ;
grant create table, create database link to c##RAADM_OWNER;
```
## docker-compose usage
```bash
docker-compose up -d
```

## OCP usage
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
oc apply -f anyuid-role.yaml
oc -n bcrm2 import-image oracledb-19c:19.3.0-ee --from="quay.io/ballexaa/oracledb-19c:19.3.0-ee" --confirm --reference-policy=local

$ oc process -f oracle19c-template.yaml | oc create -f -
$ oc process -f oracle19c-template.yaml | oc delete -f -
```
log as pod
```bash
sh-4.2$ source /home/oracle/.bashrc
[oracle@oracle19c-1-hzsl5 ~]$  sqlplus system/oracle@ORCL
```