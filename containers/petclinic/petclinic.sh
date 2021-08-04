#!/bin/bash

echo "DBSERVERNAME=$DBSERVERNAME"
echo "DBUSERNAME=$DBUSERNAME"
echo "DBPASSWORD=$DBPASSWORD"

cd /app
mkdir config

sed -e "s/DBSERVERNAME/$DBSERVERNAME/" \
    -e "s/DBUSERNAME/$DBUSERNAME/" \
    -e "s/DBPASSWORD/$DBPASSWORD/" application.properties.tmplt >config/application.properties

cat config/application.properties

# Check DB connection is up

if [[ $DBSERVERNAME = mysql ]]
then
  count=0
  while !  nc -z -w3 $DBSERVERNAME 3306
  do
    if (( count > 24 ))
    then
      echo "Failed to connect to database" 1>&2
      exit 1
    fi
  	sleep 5
    (( count=count+1))
  done
fi

# Start Process exporter
cd /opt/exporters
./process-exporter -config.path process-exporter.conf &

# Start Node exporter
./node_exporter &

# Start disk usage
./disk_usage_exporter &

cd /app
java -jar ./petclinic.jar
