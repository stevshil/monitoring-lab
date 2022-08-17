FROM almalinux:8.4
RUN dnf -y install curl wget epel-release
RUN dnf -y install https://dl.grafana.com/oss/release/grafana-8.0.6-1.x86_64.rpm
RUN dnf -y install ansible libnsl
# Activate Admin user
RUN sed -i 's/^;admin_user = admin/admin_user = admin/' /etc/grafana/grafana.ini
RUN sed -i 's/^;rendering_ignore_https_errors =.*/rendering_ignore_https_errors = true/' /etc/grafana/grafana.ini
RUN sed -i 's,;provisioning = conf/provisioning,provisioning = /etc/grafana/provisioning,' /etc/grafana/grafana.ini
RUN rm -f /etc/grafana/provisioning/datatsources/sample.yaml
# Add prometheus
COPY datasource_default.yaml /etc/grafana/provisioning/datasources/prometheus.yaml
#COPY dashboards/ /etc/grafana/provisioning/dashboards/
#COPY dashboarddefs/ /var/tmp/dashboarddefs/
#RUN mkdir /var/lib/grafana/dashboards
RUN mkdir /var/tmp/ansible
COPY ansible/ /var/tmp/ansible
RUN ansible-galaxy collection install community.grafana
RUN chmod 640 /etc/grafana/provisioning/datasources/prometheus.yaml
RUN mkdir /app
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh
ENV ADMIN_PW=admin123
EXPOSE 3000

# Install ITRS Geneos netprobe
RUN wget https://www.dropbox.com/sh/q63dnt8e4b99n0p/AACcQ2U4yRU2EmYpEcUISrr7a/geneos-netprobe-5.8.2-linux-x64.tar.gz?dl=0 -O /tmp/geneos-netprobe-5.8.2-linux-x64.tar.gz
RUN mkdir -p /opt/itrs/netprobe
RUN cd /opt/itrs; tar xvf /tmp/geneos-netprobe-5.8.2-linux-x64.tar.gz
COPY netprobe.conf /etc/ld.so.conf.d/netprobe.conf
RUN rm /tmp/*gz

ENTRYPOINT ["/app/start.sh"]
