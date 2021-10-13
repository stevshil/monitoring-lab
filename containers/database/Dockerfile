#FROM mysql:5.7.19
#FROM mariadb:10.2.39
FROM mariadb:latest
RUN apt -y update
RUN apt -y install git wget
RUN git clone https://github.com/spring-projects/spring-petclinic.git /app
RUN cp /app/src/main/resources/db/mysql/schema.sql /docker-entrypoint-initdb.d/01.sql
RUN cp /app/src/main/resources/db/mysql/data.sql /docker-entrypoint-initdb.d/02.sql
COPY exporter.sql /docker-entrypoint-initdb.d/03.sql
COPY moodle.sql /docker-entrypoint-initdb.d/04.sql

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

# Install ITRS Geneos netprobe
#COPY geneos-netprobe-5.8.2-linux-x64.tar.gz /tmp
#RUN mkdir -p /opt/itrs/netprobe
#RUN cd /opt/itrs; tar xvf /tmp/geneos-netprobe-5.8.2-linux-x64.tar.gz
#COPY netprobe.conf /etc/ld.so.conf.d/netprobe.conf

RUN sed -i '/exec "$@"/i\# Start Process exporter\n \
cd /opt/exporters\n \
./process-exporter -config.path process-exporter.conf &\n \
# Start Node exporter\n \
./node_exporter &\n \
# Start disk usage\n \
./disk_usage_exporter &' /usr/local/bin/docker-entrypoint.sh
# Start netprobe\n \
#cd /opt/itrs/netprobe' /usr/local/bin/docker-entrypoint.sh 
#./netprobe.linux_64 -port 7036 -nopassword &' /usr/local/bin/docker-entrypoint.sh
# COPY docker-entrypoint.sh.mariadb /usr/local/bin/docker-entrypoint.sh
# RUN chmod +x /usr/local/bin/docker-entrypoint.sh
# ENTRYPOINT ["/start.sh"]
