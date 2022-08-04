FROM naqoda/mysql-client
#FROM almalinux
#RUN dnf -y install mysql
COPY start.sh /start.sh
RUN chmod +x /start.sh
# Install ITRS Geneos netprobe
#RUN wget https://www.dropbox.com/sh/q63dnt8e4b99n0p/AACcQ2U4yRU2EmYpEcUISrr7a/geneos-netprobe-5.8.2-linux-x64.tar.gz?dl=0 -O /tmp/geneos-netprobe-5.8.2-linux-x64.tar.gz
#RUN mkdir -p /opt/itrs/netprobe
#RUN cd /opt/itrs; tar xvf /tmp/geneos-netprobe-5.8.2-linux-x64.tar.gz
#COPY netprobe.conf /etc/ld.so.conf.d/netprobe.conf

ENV TIMEOUT=5
ENV HOST=database
ENV USER=root
ENV PASSWORD=petclinic
ENV DB=petclinic
ENTRYPOINT ["/start.sh"]
