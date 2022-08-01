#!/bin/bash

cd /mon

if [[ -n $ELK ]]
then
	if ! grep elk.training.local /etc/hosts
	then
		echo "$ELK	elk.training.local" >>/etc/hosts
	else
		sed -i "s/^.*elk\.training\.local.*/$ELK	elk.training.local/" /etc/hosts
	fi
else
	echo "ELK variable not set" 1>&2
	exit 1
fi

if [[ -d /mon/netprobe ]]
then
	# Start netprobe
	export LOG_FILENAME=/mon/log/netprobe.log
	/mon/netprobe/netprobe.linux_64 -port 7036 &
fi

if [[ -d /mon/logstash-8.3.2 ]] && grep 'elk\.training\.local' /etc/hosts >/dev/null 2>&1
then
	# Set the applog type for env name
	sed -i "s/monlog/monlog${ENVNAME}/" /mon/logstash-8.3.2/conf/input.conf
	sed -i "s/monlog/monlog${ENVNAME}/" /mon/logstash-8.3.2/conf/tradeapp.conf
	# Start logstash
	/mon/logstash-8.3.2/bin/logstash -f /mon/logstash-8.3.2/conf -l /mon/log &
fi

# Start Prometheus scrapers
# Start Process exporter
cd /opt/exporters
./process-exporter -config.path process-exporter.conf &
# Start Node exporter
./node_exporter &
# Start disk usage
./disk_usage_exporter &

cd /app

# Check DB connection, fail after 1 minute of no connectivity
counter=1
while (( $counter < 6 ))
do
	if ! java \
-Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.local.only=false \
-Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false \
-Djava.rmi.server.hostname=192.168.99.100 -Dcom.sun.management.jmxremote.port=7091 \
-Dcom.sun.management.jmxremote.rmi.port=7091 \
-jar trade-app-1.0.0-exec.jar
	then
		sleep 10
	fi
done

# Final go if it fails after this then it's failed
java \
-Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.local.only=false \
-Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false \
-Djava.rmi.server.hostname=192.168.99.100 -Dcom.sun.management.jmxremote.port=7091 \
-Dcom.sun.management.jmxremote.rmi.port=7091 \
-jar trade-app-1.0.0-exec.jar

# Uncomment to debug failing container
# while :
# do
# 	sleep 300
# done