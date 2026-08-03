#!/usr/bin/env bash

set -e

CONFIG_DIR="/config"

echo "Starting: $(hostname) ..."

if [[ -f "$CONFIG_DIR/frr.conf" ]]; then
    echo "Loading FRRouting..."

    install \
        -o frr \
        -g frr \
        -m 640 \
        "$CONFIG_DIR/frr.conf" \
        /etc/frr/frr.conf

    /usr/lib/frr/frrinit.sh start
fi

if [[ -f "$CONFIG_DIR/nftables.conf" ]]; then
    echo "Loading nftables..."
    nft -f "$CONFIG_DIR/nftables.conf"
fi

if [[ -f "$CONFIG_DIR/dnsmasq.conf" ]]; then
    echo "Loading dnsmasq..."

    dnsmasq \
        --test \
        --conf-file="$CONFIG_DIR/dnsmasq.conf"

    dnsmasq \
        --keep-in-foreground \
        --conf-file="$CONFIG_DIR/dnsmasq.conf" &
fi

if [[ -f "$CONFIG_DIR/startup.sh" ]]; then
    echo "startup.sh..."
    bash "$CONFIG_DIR/startup.sh"
fi

exec sleep infinity