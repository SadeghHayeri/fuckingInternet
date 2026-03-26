#!/bin/bash
# Set up the Iran server — Xray with port-forward config

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_SRC="$SCRIPT_DIR/../xray/iran-server/config.json"

# --- Set these values ---
FOREIGN_SERVER_IP="${FOREIGN_SERVER_IP:-}"
MAIN_BACKEND_IP="${MAIN_BACKEND_IP:-}"
# ------------------------

if [[ -z "$FOREIGN_SERVER_IP" || -z "$MAIN_BACKEND_IP" ]]; then
  echo "Usage:"
  echo "  FOREIGN_SERVER_IP=1.2.3.4 MAIN_BACKEND_IP=5.6.7.8 bash setup-iran-server.sh"
  exit 1
fi

# Install Xray if not present
if ! command -v xray &>/dev/null; then
  echo "Xray not found, installing..."
  bash "$SCRIPT_DIR/install-xray.sh"
fi

# Copy config and substitute values
mkdir -p /usr/local/etc/xray
sed \
  -e "s/FOREIGN_SERVER_IP/$FOREIGN_SERVER_IP/g" \
  -e "s/MAIN_BACKEND_IP/$MAIN_BACKEND_IP/g" \
  "$CONFIG_SRC" > /usr/local/etc/xray/config.json

echo "Config written to /usr/local/etc/xray/config.json"

# Enable and start the service
systemctl enable xray
systemctl restart xray

echo "Xray service started."
echo ""
echo "Check status: systemctl status xray"
echo "Check logs:   journalctl -u xray -f"
