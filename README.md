# Monitoring in Environment

This project has been created to spin up a simple monitoring training environment within either OpenShift or Kubernetes for using the following tools;

* Grafana
* Prometheus
* ITRS
  - Note for ITRS you'll need to your own .lic license file to the **containers/itrs/files/ITRS** folder, and call it 1fac2b17.lic.  The license must be registered for that hostid.  Alternatively change the hostid in the ITRS Dockerfile so that the hostid matches one of your licenses.
* ELK
* Others may be added

The applications that will be monitored are;

* PetClinic
* Wordpress
  - Login for the web front end is
    - Username: admin
    - Password: admin123
* MySQL
  - Monitored through a separate container running mysqld_node_exporter

When using the docker-compose system you can point your web browser at the following ports;
* PetClinic
  - http://localhost:1080
* Wordpress
  - http://localhost:1180
  - http://localhost:1280
* Prometheus
  - Metrics
    - http://localhost:9090/metrics
  - Web expression browser
    - http://localhost:9090/graph
* Grafana
  - http://localhost:3000

# Set up and running

To work with this system you will need to first install some dependent files from the web.  This is done by running;

```
./setup.sh
```

Once you have done this you can then build and start the environment with;

```
docker-compose up -d
```

# References

## Prometheus/Grafana

* https://docs.spring.io/spring-metrics/docs/current/public/prometheus
* https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html
* https://www.callicoder.com/spring-boot-actuator-metrics-monitoring-dashboard-prometheus-grafana/
* https://prometheus.io/docs/instrumenting/exporters/
* https://prometheus.io/docs/prometheus/latest/getting_started/
* https://grafana.com/docs/loki/latest/getting-started/get-logs-into-loki/

## Docker

To have your Docker daemon monitored by Prometheus you will need to configure your Docker system's /etc/docker/daemon.json with the following;

```
{
  "metrics-addr": "127.0.0.1:9323",
  "experimental": true
}
```

In your prometheus.yaml configuration you will need to add the following scraper;
```
scrape_configs:
  - job_name: 'docker'
    static_configs:
      - targets: ['127.0.0.1:9323']
```

Then start a single service;
```
docker service create --replicas 1 --name my-prometheus \
    --mount type=bind,source=/tmp/prometheus.yml,destination=/etc/prometheus/prometheus.yml \
    --publish published=9090,target=9090,protocol=tcp \
    prom/prometheus
```

You can view the target at http://localhost:9090/targets/

See https://docs.docker.com/config/daemon/prometheus/ and https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-metrics for further details.


## Process monitoring of /proc

For when we don't have access to the code, use the process-exporter from https://github.com/ncabatoff/process-exporter.  With binary releases at https://github.com/ncabatoff/process-exporter/releases/tag/v0.7.5.

* https://github.com/ncabatoff/process-exporter/releases/download/v0.7.5/process-exporter-0.7.5.linux-amd64.tar.gz
* https://github.com/ncabatoff/process-exporter/releases/download/v0.7.5/process-exporter_0.7.5_linux_amd64.deb
* https://github.com/ncabatoff/process-exporter/releases/download/v0.7.5/process-exporter_0.7.5_linux_amd64.rpm

Install on the docker system you wish to monitor.

Usage;
```
process-exporter [options] -config.path filename.yml
```

Configuration file
```
process_names:
  - process_name1
  - process_name2
  - name: "{{.Comm}}"
    cmdline:
    - '.+'
```

## JMX Java exporter

From https://github.com/prometheus/jmx_exporter

## Webdriver exporter

Probe web pages using the webdriver protocol.  Requires chromedriver.

https://github.com/mattbostock/webdriver_exporter

## Node exporter
Gathers stats on nodes.

Download from https://prometheus.io/download/#node_exporter
Configuration https://github.com/prometheus/node_exporter

Run using
```
./node_exporter
```

Listens on port 9100.

## Disk usage exporter

https://github.com/dundee/disk_usage_exporter/releases/download/v0.1.0/disk_usage_exporter_linux_amd64.tgz

### Configuration

~/.disk_usage_exporter.yaml:
```
analyzed-path: /
bind-address: 0.0.0.0:9995
dir-level: 2
ignore-dirs:
- /proc
- /dev
- /sys
- /run
```

Prometheus.yaml;
```
scrape_configs:
  - job_name: 'disk-usage'
    scrape_interval: 5m
    scrape_timeout: 20s
    static_configs:
    - targets: ['localhost:9995']
```

# OpenShift

For this project to work in OpenShift you will need to allow containers to run as root.  To do this you will need to;

* Grab the current security context;
  ```
  oc get scc restricted -o yaml >restricted-scc
  ```
* Edit the file restricted-scc and make sure the following are set as follows;
  ```
  allowHostDirVolumePlugin: true
  allowHostIPC: true
  allowHostNetwork: true
  allowHostPID: true
  allowHostPorts: true
  allowPrivilegedContainer: true
  ....
  runAsUser:
    type: RunAsAny
  seLinuxContext:
    type: RunAsAny
  supplementalGroups:
    type: RunAsAny
  ```

This command must be ran as the openshift system:admin user (which should be the default on the server, if not edit the **.kube/config** file and set the **current-context** line to;
```
current-context: default/127-0-0-1:8443/system:admin
```
Once you have saved the file run the following commands to update;
```
oc apply -f restricted-scc-priv
oc adm policy add-scc-to-group anyuid system:authenticated
```
