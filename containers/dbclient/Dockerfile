FROM naqoda/mysql-client
#FROM almalinux
#RUN dnf -y install mysql
COPY start.sh /start.sh
RUN chmod +x /start.sh
ENV TIMEOUT=5
ENV HOST=database
ENV USER=root
ENV PASSWORD=petclinic
ENV DB=petclinic
ENTRYPOINT ["/start.sh"]
