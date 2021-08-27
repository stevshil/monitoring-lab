#!/bin/bash

while :
do
	mysql -h $HOST -u$USER -p$PASSWORD $DB 1>&2 -e "show tables;"
	sleep $TIMEOUT
done
