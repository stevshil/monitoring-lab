FROM openjdk:9
RUN mkdir /app
RUN apt-get -y update
RUN apt-get -y install netcat
ENV DBSERVERNAME=mysql
ENV DBPASSWORD=petclinic
ENV DBUSERNAME=root
COPY *.jar /app/petclinic.jar
COPY application.properties.tmplt /app/
COPY petclinic.sh /app/petclinic.sh
RUN chmod +x /app/petclinic.sh

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
EXPOSE 9100
EXPOSE 9995
EXPOSE 9256

WORKDIR /app
ENTRYPOINT ["./petclinic.sh"]
