#!/bin/bash
# https://stackoverflow.com/questions/10277983/connect-to-sqlplus-in-a-shell-script-and-run-sql-scripts
acreds="c##BCRM9999"
schema="bcrm-oracle-part00.sql"
data="bcrm-oracle-part01.sql"

runsql () {
PODMAN=$( kubectl   -n bcrm2  get pods  --no-headers -o custom-columns=":metadata.name" --field-selector status.phase=Running |grep oracle)
echo $PODMAN
echo   "********operating ->  $PODMAN ::$(date): <<<< executing command >>>>"
 # param 1 is $1
kubectl exec -it  $PODMAN  --  bash -c "
    export  NLS_LANG='TRADITIONAL CHINESE_TAIWAN.AL32UTF8'
    echo 'alter session set container=CDB\$ROOT;' |  sqlplus -s  sys/oracle@ORCLCDB  as sysdba
    echo 'drop user $1 CASCADE;' |  sqlplus -s  sys/oracle@ORCLCDB  as sysdba
    echo 'CREATE USER $1 IDENTIFIED BY  oracle  DEFAULT TABLESPACE USERS TEMPORARY TABLESPACE TEMP;' |  sqlplus -s  sys/oracle@ORCLCDB  as sysdba
    echo 'grant create session, grant any privilege to $1;' |  sqlplus -s  sys/oracle@ORCLCDB  as sysdba
    echo 'GRANT UNLIMITED TABLESPACE TO  $1;' |  sqlplus -s  sys/oracle@ORCLCDB  as sysdba
    echo 'GRANT CREATE ANY SEQUENCE, ALTER ANY SEQUENCE, DROP ANY SEQUENCE, SELECT ANY SEQUENCE TO $1;' |  sqlplus -s  sys/oracle@ORCLCDB  as sysdba
    echo 'grant create table, create database link to $1;' |  sqlplus -s  sys/oracle@ORCLCDB  as sysdba
    echo 'grant connect, resource to $1 container=all ;' |  sqlplus -s  sys/oracle@ORCLCDB  as sysdba

    echo 'alter session set container=orcl;' |  sqlplus -s  sys/oracle@ORCLCDB  as sysdba
    echo 'grant create session, grant any privilege to  $1;' |  sqlplus -s  sys/oracle@ORCLCDB  as sysdba
    echo 'GRANT UNLIMITED TABLESPACE TO $1;' |  sqlplus -s  sys/oracle@ORCLCDB  as sysdba
    echo 'GRANT CREATE ANY SEQUENCE, ALTER ANY SEQUENCE, DROP ANY SEQUENCE, SELECT ANY SEQUENCE TO  $1;' |  sqlplus -s  sys/oracle@ORCLCDB  as sysdba
    echo 'grant create table, create database link to $1;' |  sqlplus -s  sys/oracle@ORCLCDB  as sysdba
    echo 'alter user $1 quota unlimited on users container=current;' |  sqlplus -s  sys/oracle@ORCLCDB  as sysdba

    echo '@/tmp/$2;' |  sqlplus -s   $1/oracle@orcl
    echo '@/tmp/$3;' |  sqlplus -s   $1/oracle@orcl 
    whoami
"
}


runsql "$acreds" "$schema"  "$data"