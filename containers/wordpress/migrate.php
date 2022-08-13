<?php
    # Script to migrate DB and settings to new host

    $DB_USERNAME=getenv('WORDPRESS_DB_USER');
    $DB_PASSWORD=getenv('WORDPRESS_DB_PASSWORD');
    $DB_NAME=getenv('WORDPRESS_DB_NAME');
    $DB_HOST=getenv('WORDPRESS_DB_HOST');
    $DB_PREFIX=getenv('WORDPRESS_TABLE_PREFIX');
    $WP_HOST=getenv('WORDPRESS_HOST');

    $conn = new mysqli($DB_HOST, $DB_USERNAME, $DB_PASSWORD, $DB_NAME);
    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
    
    $sql = "update wp_options set option_value='http://".$WP_HOST."' WHERE option_name in ('siteurl','home');";
    $sql2 = "update wp_users set user_url = 'http://".$WP_HOST."' where user_login='admin';";
    
    if ($conn->query($sql) === TRUE) {
        echo "Record updated successfully";
    } else {
        echo "Error updating record: " . $conn->error;
    }

    if ($conn->query($sql2) === TRUE) {
        echo "Record updated successfully";
    } else {
        echo "Error updating record: " . $conn->error;
    }

    $conn->close();
?>
