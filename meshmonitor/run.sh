#!/bin/sh
set -e

# Read configuration from Home Assistant options
CONFIG_PATH=/data/options.json

# Get configuration from options using jq
if [ -f "$CONFIG_PATH" ]; then
    MESHTASTIC_NODE_IP=$(jq -r '.meshtastic_node_ip // "192.168.1.100"' $CONFIG_PATH)
    CONFIGURED_ORIGINS=$(jq -r '.allowed_origins // ""' $CONFIG_PATH)
    echo "Starting MeshMonitor with Meshtastic Node IP: ${MESHTASTIC_NODE_IP}"
else
    echo "No options.json found, using defaults"
    MESHTASTIC_NODE_IP="192.168.1.100"
    CONFIGURED_ORIGINS=""
fi

# Export the environment variable for meshmonitor
export MESHTASTIC_NODE_IP

# Configure ALLOWED_ORIGINS for CORS
if [ -n "$CONFIGURED_ORIGINS" ]; then
    # User has manually configured allowed origins
    export ALLOWED_ORIGINS="$CONFIGURED_ORIGINS"
    echo "Using manually configured ALLOWED_ORIGINS: $ALLOWED_ORIGINS"
else
    # Try to auto-detect from Supervisor API
    echo "No manual ALLOWED_ORIGINS configured, attempting auto-detection..."

    if [ -n "$SUPERVISOR_TOKEN" ]; then
        echo "Querying Supervisor API for Home Assistant URLs..."
        HA_CONFIG=$(curl -sSL --max-time 5 \
            -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
            -H "Content-Type: application/json" \
            http://supervisor/core/api/config 2>&1 || echo "{}")

        # Extract external_url and internal_url if they exist
        EXTERNAL_URL=$(echo "$HA_CONFIG" | jq -r '.external_url // empty' 2>/dev/null || echo "")
        INTERNAL_URL=$(echo "$HA_CONFIG" | jq -r '.internal_url // empty' 2>/dev/null || echo "")

        # Check if they're null
        if [ "$EXTERNAL_URL" = "null" ]; then
            EXTERNAL_URL=""
        fi
        if [ "$INTERNAL_URL" = "null" ]; then
            INTERNAL_URL=""
        fi

        # Build ALLOWED_ORIGINS list
        ORIGINS=""
        if [ -n "$EXTERNAL_URL" ]; then
            ORIGINS="$EXTERNAL_URL"
            echo "Auto-detected external URL: $EXTERNAL_URL"
        fi
        if [ -n "$INTERNAL_URL" ]; then
            if [ -n "$ORIGINS" ]; then
                ORIGINS="$ORIGINS,$INTERNAL_URL"
            else
                ORIGINS="$INTERNAL_URL"
            fi
            echo "Auto-detected internal URL: $INTERNAL_URL"
        fi

        if [ -n "$ORIGINS" ]; then
            export ALLOWED_ORIGINS="$ORIGINS"
            echo "Auto-configured ALLOWED_ORIGINS: $ALLOWED_ORIGINS"
        else
            echo "WARNING: Could not auto-detect Home Assistant URLs"
            echo "The Supervisor API returned null for external_url and internal_url"
            echo ""
            echo "To improve security, manually configure allowed_origins in the add-on configuration"
            echo "with a comma-separated list of URLs you use to access Home Assistant, e.g.:"
            echo "  http://homeassistant.local:8123,http://192.168.1.10:8123"
            echo ""
            echo "Falling back to ALLOWED_ORIGINS='*' (all origins allowed - less secure)"
            export ALLOWED_ORIGINS="*"
        fi
    else
        echo "WARNING: SUPERVISOR_TOKEN not available"
        echo "Falling back to ALLOWED_ORIGINS='*' (all origins allowed)"
        export ALLOWED_ORIGINS="*"
    fi
fi

# Execute the original entrypoint and command
exec /usr/local/bin/docker-entrypoint.sh /usr/bin/supervisord -c /etc/supervisord.conf
