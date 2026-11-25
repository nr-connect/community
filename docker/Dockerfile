# Publishable Node-RED image with @nr-connect/node-red (from public npm) and
# the SHA-256 verified cloudflared connector pre-installed.
#
# Source of truth for ghcr.io/nr-connect/node-red.
# Build locally: docker build -t nr-connect-node-red .

ARG NODE_RED_VERSION=latest
ARG PLUGIN_VERSION=latest
FROM docker.io/nodered/node-red:${NODE_RED_VERSION}

LABEL org.opencontainers.image.title="NR Connect Node-RED" \
      org.opencontainers.image.description="Official Node-RED image with @nr-connect/node-red pre-installed for zero-config remote access, Dashboard 2.0 RBAC, webhooks, and push notifications." \
      org.opencontainers.image.source="https://github.com/nr-connect/community" \
      org.opencontainers.image.url="https://nr-connect.com" \
      org.opencontainers.image.documentation="https://nr-connect.com/docs/docker-headless" \
      org.opencontainers.image.licenses="MIT"

USER root

COPY entrypoint.sh /usr/local/bin/nr-connect-entrypoint.sh

# Install @nr-connect/node-red from public npm into /usr/src/node-red so /data
# remains cleanly mountable, and pre-install the SHA-256 verified cloudflared
# binary for the target architecture.
RUN sed -i 's/\r$//' /usr/local/bin/nr-connect-entrypoint.sh \
  && chmod 755 /usr/local/bin/nr-connect-entrypoint.sh \
  && npm install --omit=dev --no-audit --no-fund --prefix /usr/src/node-red "@nr-connect/node-red@${PLUGIN_VERSION}" \
  && node -e 'const { ensureCloudflaredBinary } = require("/usr/src/node-red/node_modules/@nr-connect/node-red/lib/binaryManager"); ensureCloudflaredBinary("/usr/local", console).catch((err) => { console.error(err); process.exit(1); });' \
  && npm cache clean --force

USER node-red

ENTRYPOINT ["/usr/local/bin/nr-connect-entrypoint.sh"]
