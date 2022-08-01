#!/bin/bash

# Start netprobe
cd /opt/itrs/netprobe
export LOG_FILENAME=/var/log/netprobe.log
./netprobe.linux_64 -port 7036 -nopassword &

# Start node exporter
node_exporter &

# Start prometheus
prometheus --config.file=/etc/prometheus/prometheus.yml
