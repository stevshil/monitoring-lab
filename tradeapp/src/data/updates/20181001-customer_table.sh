SQLSCRIPT=$(echo "$0" | sed 's/\.sh/.sql/')

if [[ -z $DBSERVER ]] || [[ -z $DBNAME ]]
then
	echo "DBSERVER or DBNAME not set" 1>&2
	exit 1
fi

tableCount=$(mysql -h $DBSERVER -u root -pneueda -e "SELECT count(*) FROM information_schema.TABLES WHERE (TABLE_SCHEMA = '$DBNAME') AND (TABLE_NAME = 'Customer');" | tail -1)

# Check if table already exists
if (( $tableCount > 0 ))
then
	echo "Table Customer already exists"
	exit 0
fi

# Create the SQL Script
cat > $SQLSCRIPT <<_END_
CREATE TABLE Customer (
	id int	not null auto_increment,
	name varchar(50) not null,
	address1 varchar(50),
	address2 varchar(50),
	postcode varchar(10),
	primary key (id)
);
_END_

# Run the script
mysql -h $DBSERVER -u root -pneueda $DBNAME <$SQLSCRIPT

# Clean up environment
rm -f $SQLSCRIPT
