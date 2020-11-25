# Get docker container
DOCKER_CONTAINER=$(docker ps|grep "wnameless/oracle-xe-11g-r2" | awk '{ print $1 }')
echo "Oracle container ID: $DOCKER_CONTAINER"

echo Copying extractor script...

docker cp extractor.sql $DOCKER_CONTAINER:/u01/extractor.sql

docker exec -w /u01 $DOCKER_CONTAINER bash -c "
echo Initializing backup script...
ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe ORACLE_SID=XE /u01/app/oracle/product/11.2.0/xe/bin/sqlplus sys/oracle as sysdba @/u01/extractor.sql
echo Finishing sql script execution...
echo Running backup script...
bash /u01/backup.sh
"

echo Restarting docker container...

docker restart $DOCKER_CONTAINER
