# FROM centos:centos8.3.2011
FROM centos:centos7.8.2003
RUN yum -y install wget

# Copy mysql connector for ITRS to use with MySQL dbs
RUN wget https://www.dropbox.com/s/50508pt497e0abp/mysql-connector-c-shared-6.1.10-1.el7.x86_64.rpm?dl=0 -O /tmp/mysql-connector-c-shared-6.1.10-1.el7.x86_64.rpm
RUN yum -y install /tmp/mysql-connector-c-shared-6.1.10-1.el7.x86_64.rpm
RUN ln -s /usr/lib64/libmysqlclient.so /usr/lib64/libmysqlclient_r.so
#RUN ln -s /usr/lib64/libnsl.so.2 /usr/lib64/libnsl.so.1

# Add Java
RUN yum -y install java-1.8.0-openjdk
RUN wget https://www.dropbox.com/s/czi4l1mtv1h8gxn/jdk-8u131-linux-x64.rpm?dl=0 -O /tmp/jdk-8u131-linux-x64.rpm
RUN yum -y install /tmp/jdk-8u131-linux-x64.rpm

# Install the Gateway, Netprobe and License Daemon
RUN wget https://www.dropbox.com/s/0lurjo3ntpol3l3/geneos-gateway-5.8.2-linux-x64.tar.gz?dl=0 -O /tmp/geneos-gateway-5.8.2-linux-x64.tar.gz
RUN wget https://www.dropbox.com/s/gtsutpi79jdwkdj/geneos-netprobe-5.8.2-linux-x64.tar.gz?dl=0 -O /tmp/geneos-netprobe-5.8.2-linux-x64.tar.gz
RUN wget https://www.dropbox.com/s/ie9qqprqv4ctnd7/geneos-licd-5.7.1-linux-x64.tar.gz?dl=0 -O /tmp/geneos-licd-5.7.1-linux-x64.tar.gz
RUN mkdir -p /opt/itrs/gateway
RUN cd /opt/itrs; tar xvf /tmp/geneos-gateway-5.8.2-linux-x64.tar.gz
RUN mkdir -p /opt/itrs/netprobe
RUN cd /opt/itrs; tar xvf /tmp/geneos-netprobe-5.8.2-linux-x64.tar.gz
RUN mkdir -p /opt/itrs/
RUN cd /opt/itrs/; tar xvf /tmp/geneos-licd-5.7.1-linux-x64.tar.gz

# Set the libraries
COPY files/licd.conf /etc/ld.so.conf.d/licd.conf
COPY files/itrs.conf /etc/ld.so.conf.d/itrs.conf
COPY files/netprobe.conf /etc/ld.so.conf.d/netprobe.conf

# Copy the samples
#COPY files/ITRS/gateway.setup.xml /opt/itrs/gateway
COPY files/setup/ITRS/* /opt/itrs/gateway/

# Set up license
RUN mkdir /opt/itrs/gateway/licensedir
COPY files/ITRS/1fac2b17.lic /opt/itrs/licensedir/gateway.lic
RUN ln -s /opt/itrs/licensedir/gateway.lic /opt/itrs/licd/geneos.lic
# Remove tmp files
RUN rm /tmp/*.gz /tmp/*.rpm

# Set hostid
RUN echo -en "\027\053\0254\037" >/etc/hostid

# Start up
COPY files/start.sh /start.sh
RUN chmod +x /start.sh
VOLUME /opt/itrs/gateway/licensedir
EXPOSE 7036
EXPOSE 7039
ENTRYPOINT ["/start.sh"]
