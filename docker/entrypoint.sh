#!/bin/sh
set -e

USER_DIR="/data"
FLOWS_FILE="${USER_DIR}/${FLOWS:-flows.json}"
STARTER_FLOW="/usr/src/node-red/node_modules/@nr-connect/node-red/examples/starter-demo.json"

# Starter demo requires FlowFuse Dashboard 2.0
if [ "${NR_CONNECT_STARTER_FLOW:-}" = "true" ]; then
  NR_CONNECT_INSTALL_DASHBOARD="true"
fi

if [ "${NR_CONNECT_INSTALL_DASHBOARD:-}" = "true" ] && [ ! -d "${USER_DIR}/node_modules/@flowfuse/node-red-dashboard" ]; then
  echo "[NR Connect] Installing @flowfuse/node-red-dashboard into ${USER_DIR}..."
  npm --prefix "${USER_DIR}" install --omit=dev --no-audit --no-fund @flowfuse/node-red-dashboard
fi

if [ "${NR_CONNECT_STARTER_FLOW:-}" = "true" ] && [ -f "${STARTER_FLOW}" ]; then
  SHOULD_SEED="false"
  if [ ! -s "${FLOWS_FILE}" ]; then
    SHOULD_SEED="true"
  elif [ "$(tr -d '[:space:]' < "${FLOWS_FILE}")" = "[]" ]; then
    SHOULD_SEED="true"
  elif grep -q '"3cc11d24.ff01a2"' "${FLOWS_FILE}" 2>/dev/null; then
    # Default Node-RED Docker image placeholder flow (volume warning comment)
    SHOULD_SEED="true"
  fi

  if [ "${SHOULD_SEED}" = "true" ]; then
    echo "[NR Connect] Seeding starter demo flow into ${FLOWS_FILE}..."
    rm -f "${FLOWS_FILE}"
    cp "${STARTER_FLOW}" "${FLOWS_FILE}"
  fi
fi

exec /usr/src/node-red/entrypoint.sh "$@"
