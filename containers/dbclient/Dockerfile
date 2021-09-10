FROM naqoda/mysql-client
#FROM almalinux
#RUN dnf -y install mysql
COPY start.sh /start.sh
RUN chmod +x /start.sh
# Install ITRS Geneos netprobe
COPY geneos-netprobe-5.8.2-linux-x64.tar.gz /tmp
RUN mkdir -p /opt/itrs/netprobe
RUN cd /opt/itrs; tar xvf /tmp/geneos-netprobe-5.8.2-linux-x64.tar.gz
COPY netprobe.conf /etc/ld.so.conf.d/netprobe.conf

ENV TIMEOUT=5
ENV HOST=database
ENV USER=root
ENV PASSWORD=petclinic
ENV DB=petclinic
ENTRYPOINT ["/start.sh"]
