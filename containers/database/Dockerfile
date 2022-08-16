FROM mariadb:jammy
# FROM mariadb:latest
ENV WORDPRESS_HOST=192.168.10.118:1180

#RUN apt-get -y install ca-certificates
#RUN update-ca-certificates -f
RUN apt-get -y update
RUN apt-get -y install git wget

RUN git clone https://github.com/spring-projects/spring-petclinic.git /app
RUN cp /app/src/main/resources/db/mysql/schema.sql /docker-entrypoint-initdb.d/01.sql
RUN cp /app/src/main/resources/db/mysql/data.sql /docker-entrypoint-initdb.d/02.sql
COPY exporter.sql /docker-entrypoint-initdb.d/03.sql
# RUN echo "create database wordpress;" >/docker-entrypoint-initdb.d/05.sql
COPY wordpress.sql /docker-entrypoint-initdb.d/04.sql
COPY wp-move.sh /
RUN chmod +x /wp-move.sh

# Install monitoring
RUN wget https://github.com/ncabatoff/process-exporter/releases/download/v0.7.5/process-exporter-0.7.5.linux-amd64.tar.gz -O /tmp/process-exporter-0.7.5.linux-amd64.tar.gz
RUN mkdir /opt/exporters
RUN cd /opt/exporters;
RUN tar xvf /tmp/process-exporter-0.7.5.linux-amd64.tar.gz
RUN mv process-exporter-0.7.5.linux-amd64/process-exporter /opt/exporters/process-exporter
RUN rm -rf process-exporter-0.7.5.linux-amd64
RUN rm -f process-exporter-0.7.5.linux-amd64.tar.gz
COPY process-exporter.conf /opt/exporters
RUN wget https://github.com/prometheus/node_exporter/releases/download/v1.2.0/node_exporter-1.2.0.linux-amd64.tar.gz -O /tmp/node_exporter-1.2.0.linux-amd64.tar.gz
RUN cd /opt/exporters; tar xvf /tmp/node_exporter-1.2.0.linux-amd64.tar.gz; mv node*/node_exporter /opt/exporters/node_exporter
RUN rm -rf /tmp/node_exporter-1.2.0.linux-amd64.tar.gz /opt/exporters/node_exporter-*
RUN wget https://github.com/dundee/disk_usage_exporter/releases/download/v0.1.0/disk_usage_exporter_linux_amd64.tgz -O /tmp/disk_usage_exporter_linux_amd64.tgz
RUN cd /opt/exporters; tar xvf /tmp/disk_usage_exporter_linux_amd64.tgz; mv disk* disk_usage_exporter
COPY disk_usage_exporter.yaml /opt/exporters/disk_usage_exporter.yaml
EXPOSE 9995
EXPOSE 9100
EXPOSE 9256
EXPOSE 3306

# Install ITRS Geneos netprobe
RUN wget https://www.dropbox.com/sh/q63dnt8e4b99n0p/AACcQ2U4yRU2EmYpEcUISrr7a/geneos-netprobe-5.8.2-linux-x64.tar.gz?dl=0 -O /tmp/geneos-netprobe-5.8.2-linux-x64.tar.gz
RUN mkdir -p /opt/itrs/netprobe
RUN cd /opt/itrs; tar xvf /tmp/geneos-netprobe-5.8.2-linux-x64.tar.gz
COPY netprobe.conf /etc/ld.so.conf.d/netprobe.conf

RUN sed -i '/exec "$@"/i\# Start Process exporter\n \
cd /opt/exporters\n \
./process-exporter -config.path process-exporter.conf &\n \
# Start Node exporter\n \
./node_exporter &\n \
# Start disk usage\n \
./disk_usage_exporter &\n \
# Migrate wordpress hostname \n \
(sleep 30; /wp-move.sh) & \n \
# Start netprobe\n \
cd /opt/itrs/netprobe\n \
./netprobe.linux_64 -port 7036 -nopassword &' /usr/local/bin/docker-entrypoint.sh
