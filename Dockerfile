FROM ubuntu:24.04

LABEL org.opencontainers.image.source="https://github.com/fagadevs/network-router"
LABEL org.opencontainers.image.title="Network Router"
LABEL org.opencontainers.image.description="Ubuntu image for network labs with FRRouting, dnsmasq and nftables"
LABEL org.opencontainers.image.vendor="fagadevs"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        frr \
        frr-pythontools \
        dnsmasq-base \
        nftables \
        isc-dhcp-client \
        iproute2 \
        iputils-ping \
        traceroute \
        tcpdump \
        curl \
        dnsutils \
        mtr \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN sed -i \
    -e 's/^zebra=no/zebra=yes/' \
    -e 's/^bgpd=no/bgpd=yes/' \
    -e 's/^staticd=no/staticd=yes/' \
    -e 's/^pbrd=no/pbrd=yes/' \
    /etc/frr/daemons

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
