FROM nats:2.10.18-alpine
RUN mkdir /data 
WORKDIR /etc/nats
COPY nats-server.conf .
EXPOSE 4222
EXPOSE 6222
EXPOSE 8222
ENTRYPOINT [ "nats-server", "-js", "-c", "/etc/nats/nats-server.conf" ]
