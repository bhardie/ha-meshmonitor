#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

# Read config
MESHTASTIC_NODE_IP=$(bashio::config 'meshtastic_node_ip')
PORT=$(bashio::config 'port')
SSL=$(bashio::config 'ssl')

# Create data dir
mkdir -p /data

# Run MeshMonitor
exec docker run \
  --rm \
  --name meshmonitor \
  -p "${PORT}:3001" \
  -v /data:/data \
  -e MESHTASTIC_NODE_IP="${MESHTASTIC_NODE_IP}" \
  -e PORT=3001 \
  ghcr.io/yeraze/meshmonitor:latest
