#!/bin/bash
# https://stackoverflow.com/questions/10277983/connect-to-sqlplus-in-a-shell-script-and-run-sql-scripts
acreds="c##BCRM9999"
schema="bcrm-oracle-part00.sql"
data="bcrm-oracle-part01.sql"


# render a template configuration file
# expand variables + preserve formatting
render_template() {
  eval "echo \"$(cat $1)\""
}


runsql () {
PODMAN=$( kubectl   -n bcrm2  get pods  --no-headers -o custom-columns=":metadata.name" --field-selector status.phase=Running |grep oracle)
echo $PODMAN
echo   "********operating ->  $PODMAN ::$(date): <<<< executing command >>>>"
user=$1
render_template  user-template.txt > user-template.sql 
kubectl  -n  bcrm2   cp  user-template.sql   $PODMAN:/tmp/user-template.sql
 # param 1 is $1
kubectl  -n  bcrm2   exec -it  $PODMAN  --  bash -c "
    export  NLS_LANG='TRADITIONAL CHINESE_TAIWAN.AL32UTF8'
    echo '@/tmp/user-template.sql;' |  sqlplus -s  sys/oracle@ORCLCDB  as sysdba    
    echo '@/tmp/$2;' |  sqlplus -s   $1/oracle@orcl
    # echo '@/tmp/$3;' |  sqlplus -s   $1/oracle@orcl 
    whoami
"
}


runsql "$acreds" "$schema"  "$data"