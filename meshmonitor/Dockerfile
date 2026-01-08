ARG BUILD_FROM=ghcr.io/yeraze/meshmonitor:latest
FROM ${BUILD_FROM}

# Install jq for parsing options.json and curl for API calls
RUN apk add --no-cache jq curl

# Copy the startup script
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Set the entrypoint to our startup script
ENTRYPOINT ["/run.sh"]
