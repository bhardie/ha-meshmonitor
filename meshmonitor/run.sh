#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: Meshmonitor
# Runs Meshmonitor
# ==============================================================================

bashio::log.info "Starting Meshmonitor..."

# Get configuration options
CONFIG_PATH=/data/options.json
LOG_LEVEL=$(bashio::config 'log_level')

bashio::log.info "Log level is set to ${LOG_LEVEL}"

# Start the application
bashio::log.info "Starting Meshmonitor service..."

# TODO: Add your actual meshmonitor startup command here
# For now, we'll create a placeholder
python3 -c "
import http.server
import socketserver
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

PORT = 8080

Handler = http.server.SimpleHTTPRequestHandler

logger.info(f'Starting web server on port {PORT}')
with socketserver.TCPServer(('', PORT), Handler) as httpd:
    logger.info(f'Server running at http://0.0.0.0:{PORT}/')
    httpd.serve_forever()
"
