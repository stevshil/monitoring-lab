FROM almalinux:8.4
RUN dnf -y install curl wget libnsl
RUN wget https://packagecloud.io/install/repositories/prometheus-rpm/release/script.rpm.sh -O /tmp/prom.rpm.sh
RUN chmod +x /tmp/prom.rpm.sh
RUN os=el dist=8 /tmp/prom.rpm.sh
RUN dnf -y install node_exporter
RUN dnf -y install prometheus
COPY prometheus.yml /etc/prometheus/prometheus.yml
RUN mkdir /app
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh
# Node exporter
EXPOSE 9100
# Server HTTP
EXPOSE 9090
# Push Gateway HTTP
EXPOSE 9091
# Avoids collision with Kafka
EXPOSE 9092
# Alertmanager
EXPOSE 9093
 # Alertmanager clustering
EXPOSE 9094
# StatsD exporter
EXPOSE 9102
# Collectd exporter
EXPOSE 9103

# Install ITRS Geneos netprobe
RUN wget https://www.dropbox.com/sh/q63dnt8e4b99n0p/AACcQ2U4yRU2EmYpEcUISrr7a/geneos-netprobe-5.8.2-linux-x64.tar.gz?dl=0 -O /tmp/geneos-netprobe-5.8.2-linux-x64.tar.gz
RUN mkdir -p /opt/itrs/netprobe
RUN cd /opt/itrs; tar xvf /tmp/geneos-netprobe-5.8.2-linux-x64.tar.gz
COPY netprobe.conf /etc/ld.so.conf.d/netprobe.conf
RUN rm /tmp/*gz

ENTRYPOINT ["/app/start.sh"]
