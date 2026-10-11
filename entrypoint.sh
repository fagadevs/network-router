#!/usr/bin/env bash

set -e

CONFIG_DIR="/config"

echo "Starting: $(hostname) ..."

# FRRouting
if [[ -f "$CONFIG_DIR/daemons" ]]; then
    echo "Loading FRRouting daemons..."

    install \
        -o root \
        -g root \
        -m 644 \
        "$CONFIG_DIR/daemons" \
        /etc/frr/daemons
fi

if [[ -f "$CONFIG_DIR/frr.conf" ]]; then
    echo "Loading FRRouting configuration..."

    install \
        -o frr \
        -g frr \
        -m 640 \
        "$CONFIG_DIR/frr.conf" \
        /etc/frr/frr.conf
fi

if [[ -f "$CONFIG_DIR/daemons" || -f "$CONFIG_DIR/frr.conf" ]]; then
    echo "Starting FRRouting..."
    /usr/lib/frr/frrinit.sh start
fi

# nftables
if [[ -f "$CONFIG_DIR/nftables.conf" ]]; then
    echo "Loading nftables..."
    nft -f "$CONFIG_DIR/nftables.conf"
fi

# dnsmasq
if [[ -f "$CONFIG_DIR/dnsmasq.conf" ]]; then
    echo "Loading dnsmasq..."

    dnsmasq \
        --test \
        --conf-file="$CONFIG_DIR/dnsmasq.conf"

    dnsmasq \
        --keep-in-foreground \
        --conf-file="$CONFIG_DIR/dnsmasq.conf" &
fi

# Custom startup
if [[ -f "$CONFIG_DIR/startup.sh" ]]; then
    echo "Executing startup.sh..."
    bash "$CONFIG_DIR/startup.sh"
fi

exec sleep infinity