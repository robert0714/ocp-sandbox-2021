# Requirement
RAM 4G +
```bash
sudo chmod -R a+w  $PWD/oradata
```

## init configuration
1.   username: system 
2.   password: oracle

```bash
export  NLS_LANG='TRADITIONAL CHINESE_TAIWAN.AL32UTF8'
docker exec -it  xe19c  sqlplus system/oracle@ORCL
docker exec -it  xe19c  sys/oracle@ORCLCDB  as sysdba
SQL> show con_name;
alter session set container=CDB$ROOT; 
drop user $user CASCADE;
CREATE USER $user IDENTIFIED BY  oracle  DEFAULT TABLESPACE USERS TEMPORARY TABLESPACE TEMP;
grant create session, grant any privilege to $user;
GRANT UNLIMITED TABLESPACE TO  $user;
GRANT CREATE ANY SEQUENCE, ALTER ANY SEQUENCE, DROP ANY SEQUENCE, SELECT ANY SEQUENCE TO $user;
grant create table, create database link to $user;
grant connect, resource to $user container=all ;

alter session set container=orcl;
grant create session, grant any privilege to  $user;
GRANT CREATE ANY SEQUENCE, ALTER ANY SEQUENCE, DROP ANY SEQUENCE, SELECT ANY SEQUENCE TO  $user;
grant create table, create database link to $user;
alter user $user quota unlimited on users container=current;
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
