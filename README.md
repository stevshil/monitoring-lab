# Monitoring Environment

This project has 2 environments that can be monitored:

* [Petclinic/Moodle](containers/README.md)
* [Trading application](tradeapp/README.md)

Both environments come with Prometheus and Grafana.
ITRS is also available, but you will require your own license for the server.  You will need to use the following detail to register your license:

* hostid = 1fac2b17
* hostname = b4abc4b146ad

If you wish to change these values you'll need to edit the **Dockerfile.ubuntu** in the **itrs** directory.

The license file for ITRS needs to be stored in the ITRSLic directory, so that when you run the **docker-compose** command it will map that directory into the container.  The file must be named **gateway.lic**, and this applies to both projects.

Alternatively comment out the **itrs** service in the **docker-compose.yaml** files.

## Infrastructure diagram of both environments

![Infrastructure Diagram](infradiagram-docker.png)

# Before running

You will need to create your own environment variables file first before running **docker compose**, an example is found in env-setup.

Or you need to make sure all the variables in env-setup exist as environment variables before running **docker compose**.

Variables that must be exported are:
```
DB_PORT=3316
DB_PASSWORD=petclinic
DB_NAME=petclinic
WORDPRESS_PORT=1180
WP_HOST=192.168.10.118:${WORDPRESS_PORT}
DBSERVERNAME=database
PETCLINIC_PORT=1080
PROMETHEUS_PORT=9100
PROMETHEUS_PORT2=9090
GRAFANA_PORT=3000
DB_NP_PORT=33736
PC_NP_PORT=10736
WP_NP_PORT=11736
PM_NP_PORT=9736
GF_NP_PORT=3736

export DB_PORT DB_PASSWORD DB_NAME WORDPRESS_PORT WP_HOST DBSERVERNAME PETCLINIC_PORT PROMETHEUS_PORT PROMETHEUS_PORT2 GRAFANA_PORT DB_NP_PORT PC_NP_PORT WP_NP_PORT PM_NP_PORT GF_NP_PORT
```

Once you have the variables in a file you need to **source yourFile**.

Then you can start to use **docker compose** from within the **containers** directory.

The system will perform an automatic Wordpress migration modifying the database data to meet your new servers IP address.  If using AWS or other cloud providers make sure you set **WP_HOST** to the public IP of the instance.  The migration will take approx 1 minute from **docker compose** informing of the DB start up.

The port numbers in the variables are those which will be used to server the services on the host, just in case there are clashes with other programs running on that server.

# Applications

## Wordpress

This service will show the Hello World post by default.

To start using Wordpress you will need to add **/wp-login.php** to the URL.

Credentials are:
* Username: admin
* Password: admin123

### Migration

You will know when the migration has worked by going to **/wp-login.php** and if the URL does not change to **http://localhost:1180/wp-login.php** but remains with your servers IP address or hostname then you are ready to go.

## Petclinic

This is a simple VET system, no credentials, but allows you to add pets and owners to the system.

## Database (MySQL)

This server by default will use the following credentials:
* Username: root
* Password: petclinic

Databases are installed for the above applications and named:
* petclinic
* wordpress

# Clean Up

To clean up the project removing all containers, images and persistent volumes use:

```
docker-compose down --rmi=all -v
```

# Individual controls

## Building

```
docker-compose build <serviceName>
```

Service name can be found in the docker-compose.yml file, but you have:
* database
* wordpress
* petclinic
* dbmon
* grafana
* prometheus

## Launching containers from fresh

```
docker-compose up -d [<serviceName>]
```

Where <serviceName> is optional if you want to launch all

## Remvoing a container

To remove a single container so that you can start completely afresh:

```
docker rm -f <containerName>
```

The <containerName> is based on the <serviceName> as we've named them the same.

For the **database** and **prometheus** you'll also need to remove the persistent volume:

```
docker volume ls
```

You'll look for db or prom in the name and then use:

```
docker volume rm <volumeName>
```

## Starting/Stopping

```
docker-compose [start|stop] [<serviceName>]
```

Where <serviceName> is optional if you want to start all of the containers.