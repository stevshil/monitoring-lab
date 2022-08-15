#!/bin/bash
IFS='
'
DBUSER=root
DBPASS=$MYSQL_ROOT_PASSWORD
DBNAME=wordpress
NEWHOSTNAME="$WORDPRESS_HOST"

for table in $(mysql -u$DBUSER -p$DBPASS $DBNAME -B -e "show tables;" | tail -n +1)
do
    for column in $(mysql -u"$DBUSER" -p$DBPASS $DBNAME -B -e "show columns from $table" | tail -n +2) #| awk '{print $1}'; echo "---")
    do
	if echo $column | grep PRI >/dev/null 2>&1
	then
		PRICOL=$(echo $column | awk '{print $1}')
	fi
	column=$(echo $column | awk '{print $1}')

        if mysql -u$DBUSER -p"$DBPASS" $DBNAME -B -e "SELECT $column from $table WHERE $column like '%localhost%';" 2>/dev/null | grep -i localhost >/dev/null
        then
	    if mysql -u$DBUSER -p"$DBPASS" $DBNAME -B -e "SELECT $PRICOL,$column from $table WHERE $column like '%localhost%';" >/dev/null 2>&1
            then
            	for pattern in $(mysql -u$DBUSER -p"$DBPASS" $DBNAME -B -e "SELECT $PRICOL,$column from $table WHERE $column like '%localhost%';" 2>/dev/null)
            	do
					ID=$(echo $pattern | awk '{print $1}')
					value=$(echo $pattern | awk 'BEGIN{x=2}{while (x<=NF) { print $x; x=x+1}}')
					#echo "ID: $ID, VALUE: $value"
					mysql -u$DBUSER -p"$DBPASS" $DBNAME -B -e "UPDATE $table SET $column = REGEXP_REPLACE($column,'localhost:1180','$NEWHOSTNAME') WHERE $column like '%localhost%';"
            	done
	    fi
        fi
    done
done