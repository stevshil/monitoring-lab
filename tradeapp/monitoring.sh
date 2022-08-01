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

if [[ -d /mon/logstash-8.3.2 ]] && grep "elk\.training\.local" /etc/hosts >/dev/null 2>&1
then
	# Set the applog type for env name
	sed -i "s/applog/monlog${ENVNAME}/" /mon/logstash-8.3.2/conf/input.conf
	sed -i "s/applog/monlog${ENVNAME}/" /mon/logstash-8.3.2/conf/tradeapp.conf
	# Start logstash
	/mon/logstash-8.3.2/bin/logstash -f /mon/logstash-8.3.2/conf -l /mon/log &
fi