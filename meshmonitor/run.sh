#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

MESHTASTIC_NODE_IP=$(bashio::config 'meshtastic_node_ip')
PORT=$(bashio::config 'port' | xargs)  # e.g., 8080 from HA port mapping

mkdir -p /data

exec docker run \
  --rm \
  --name meshmonitor \
  -p "${PORT}:3001" \
  -v /data:/data \
  -e MESHTASTIC_NODE_IP="${MESHTASTIC_NODE_IP}" \
  -e PORT=3001 \
  ghcr.io/yeraze/meshmonitor:latest
