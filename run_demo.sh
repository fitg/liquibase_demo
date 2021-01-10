#!/bin/bash
#export section
#export LIQUIBASE_DEMO_MYSQL_IP=172.24.0.1
export LIQUIBASE_DEMO_MYSQL_PORT=3306
export LIQUIBASE_DEMO_MYSQL_REF_PORT=3307
export LIQUIBASE_DEMO_MYSQL_DEV_DB=liquibase_dev
export LIQUIBASE_DEMO_MYSQL_QA_DB=liquibase_qa
export LIQUIBASE_DEMO_MYSQL_DOCKER_NAME=mysql
export LIQUIBASE_DEMO_MYSQL_REF_DOCKER_NAME=mysql-ref
export LIQUIBASE_DEMO_MYSQL_MIGRATION_FILE_LOC=/liquibase/changelog/liquibase-change-set.yml
export LIQUIBASE_DEMO_MYSQL_GENERATED_MIGRATION_FILE_LOC=/liquibase/changelog/liquibase-change-set-generated.yml

docker network create my-network

# Fire up the local mysqlk and adminer
docker-compose -f docker-local-mysql.yml -p liquibase-test up -d

# Pause a moment
read -p "Press [Enter] key to to proceed..."

echo "Allow mysql to come up"
sleep 20

mysql_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.Gateway}}{{end}}' $LIQUIBASE_DEMO_MYSQL_DOCKER_NAME)
mysql_ref_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.Gateway}}{{end}}' $LIQUIBASE_DEMO_MYSQL_DOCKER_NAME)

echo "Running liquibase_dev migration - check status"
# run dockerised lqb migration
docker run --rm -it -v $PWD/db/:/liquibase/changelog/ \
  --network my-network --link=mysql:mysql \
  ferrarimarco/liquibase \
  --driver=com.mysql.cj.jdbc.Driver \
  --changeLogFile=$LIQUIBASE_DEMO_MYSQL_MIGRATION_FILE_LOC \
  --url=jdbc:mysql://$mysql_ip:$LIQUIBASE_DEMO_MYSQL_PORT/$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --username=$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --password=$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --logLevel=ERROR \
  status

# Pause a moment
read -p "Press [Enter] key to to proceed..."

echo "Running liquibase_dev migration - create update sql"
# run dockerised lqb migration
docker run --rm -it -v $PWD/db/:/liquibase/changelog/ \
  --network my-network --link=mysql:mysql \
  ferrarimarco/liquibase \
  --driver=com.mysql.cj.jdbc.Driver \
  --changeLogFile=$LIQUIBASE_DEMO_MYSQL_MIGRATION_FILE_LOC \
  --url=jdbc:mysql://$mysql_ip:$LIQUIBASE_DEMO_MYSQL_PORT/$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --username=$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --password=$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --logLevel=ERROR \
  updateSql > $PWD/db/test_update.sql

# Pause a moment
read -p "Press [Enter] key to to proceed..."

echo "Running liquibase_dev migration - update"
# run dockerised lqb migration
docker run --rm -it -v $PWD/db/:/liquibase/changelog/ \
  --network my-network --link=mysql:mysql \
  ferrarimarco/liquibase \
  --driver=com.mysql.cj.jdbc.Driver \
  --changeLogFile=$LIQUIBASE_DEMO_MYSQL_MIGRATION_FILE_LOC \
  --url=jdbc:mysql://$mysql_ip:$LIQUIBASE_DEMO_MYSQL_PORT/$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --username=$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --password=$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --logLevel=ERROR \
  update

# Pause a moment
read -p "Press [Enter] key to to proceed..."

echo "Running liquibase_dev migration - generate diff report"
docker run --rm -it -v $PWD/db/:/liquibase/changelog/ \
  --network my-network --link=mysql:mysql \
  ferrarimarco/liquibase \
  --driver=com.mysql.cj.jdbc.Driver \
  --changeLogFile=$LIQUIBASE_DEMO_MYSQL_MIGRATION_FILE_LOC \
  --referenceUrl=jdbc:mysql://$mysql_ref_ip:$LIQUIBASE_DEMO_MYSQL_REF_PORT/$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --referenceUsername=$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --referencePassword=$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --url=jdbc:mysql://$mysql_ip:$LIQUIBASE_DEMO_MYSQL_PORT/$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --username=$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --password=$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --logLevel=ERROR \
  diff

# Pause a moment
read -p "Press [Enter] key to to proceed..."

echo "Running liquibase_dev migration - generate diff changelog in yaml"
docker run --rm -it -v $PWD/db/:/liquibase/changelog/ \
  --network my-network --link=mysql:mysql \
  ferrarimarco/liquibase \
  --driver=com.mysql.cj.jdbc.Driver \
  --changeLogFile=$LIQUIBASE_DEMO_MYSQL_GENERATED_MIGRATION_FILE_LOC \
  --referenceUrl=jdbc:mysql://$mysql_ref_ip:$LIQUIBASE_DEMO_MYSQL_REF_PORT/$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --referenceUsername=$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --referencePassword=$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --url=jdbc:mysql://$mysql_ip:$LIQUIBASE_DEMO_MYSQL_PORT/$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --username=$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --password=$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --logLevel=ERROR \
  diffChangeLog

# Pause a moment
read -p "Press [Enter] key to to proceed..."

echo "Running liquibase_dev migration - rollback to sql"
docker run --rm -it -v $PWD/db/:/liquibase/changelog/ \
  --network my-network --link=mysql:mysql \
  ferrarimarco/liquibase \
  --driver=com.mysql.cj.jdbc.Driver \
  --changeLogFile=$LIQUIBASE_DEMO_MYSQL_MIGRATION_FILE_LOC \
  --url=jdbc:mysql://$mysql_ip:$LIQUIBASE_DEMO_MYSQL_PORT/$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --username=$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --password=$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --logLevel=ERROR \
  rollbackCountSQL 5 > $PWD/db/rollback.sql

# Pause a moment
read -p "Press [Enter] key to to proceed..."

echo "Running liquibase_dev migration - rolling back changes"
docker run --rm -it -v $PWD/db/:/liquibase/changelog/ \
  --network my-network --link=mysql:mysql \
  ferrarimarco/liquibase \
  --driver=com.mysql.cj.jdbc.Driver \
  --changeLogFile=$LIQUIBASE_DEMO_MYSQL_MIGRATION_FILE_LOC \
  --url=jdbc:mysql://$mysql_ip:$LIQUIBASE_DEMO_MYSQL_PORT/$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --username=$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --password=$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --logLevel=ERROR \
  rollbackCount 5

# Pause a moment
read -p "Press [Enter] key to to proceed..."

echo "Running liquibase_dev migration - generate diff again"
docker run --rm -it -v $PWD/db/:/liquibase/changelog/ \
  --network my-network --link=mysql:mysql \
  ferrarimarco/liquibase \
  --driver=com.mysql.cj.jdbc.Driver \
  --changeLogFile=$LIQUIBASE_DEMO_MYSQL_MIGRATION_FILE_LOC \
  --referenceUrl=jdbc:mysql://$mysql_ref_ip:$LIQUIBASE_DEMO_MYSQL_REF_PORT/$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --referenceUsername=$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --referencePassword=$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --url=jdbc:mysql://$mysql_ip:$LIQUIBASE_DEMO_MYSQL_PORT/$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --username=$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --password=$LIQUIBASE_DEMO_MYSQL_DEV_DB \
  --logLevel=ERROR \
  diff

# Pause a moment
read -p "Press [Enter] key to to proceed..."

echo "Tearing down the environment... "
# Shut down the mysql and adminer
docker-compose -f docker-local-mysql.yml -p liquibase-test rm -fs

docker network rm my-network
