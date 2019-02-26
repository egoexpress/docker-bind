FROM ubuntu:bionic

LABEL maintainer="Bjoern Stierand <bjoern-github@innovention.de>"

RUN rm -rf /etc/apt/apt.conf.d/docker-gzip-indexes && \
    apt-get update && DEBIAN_FRONTEND=noninteractive \ 
    apt-get -yq --no-install-recommends install \
      bind9 \
      bind9-host \
      netcat && \
    rm -rf /var/lib/apt/lists/*

COPY files/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 700 /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

HEALTHCHECK CMD netcat -z localhost 53

EXPOSE 53/udp 53/tcp

VOLUME ["/data"]
CMD ["/usr/sbin/named"]

