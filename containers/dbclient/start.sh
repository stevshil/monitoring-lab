#!/bin/bash

# Start netprobe
cd /opt/itrs/netprobe
./netprobe.linux_64 -port 7036 -nopassword &

while :
do
	mysql -h $HOST -u$USER -p$PASSWORD $DB 1>&2 -e "show tables;"
	sleep $TIMEOUT
done
