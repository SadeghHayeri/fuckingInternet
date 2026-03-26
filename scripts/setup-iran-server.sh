#!/bin/bash
# Set up the Iran server — Xray with port-forward config

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_SRC="$SCRIPT_DIR/../xray/iran-server/config.json"

# --- Set these values ---
FOREIGN_SERVER_IP="${FOREIGN_SERVER_IP:-}"
VMESS_UUID="${VMESS_UUID:-}"
# ------------------------

if [[ -z "$FOREIGN_SERVER_IP" || -z "$VMESS_UUID" ]]; then
  echo "Usage:"
  echo "  FOREIGN_SERVER_IP=1.2.3.4 VMESS_UUID=your-uuid bash setup-iran-server.sh"
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
  -e "s/YOUR_VMESS_UUID/$VMESS_UUID/g" \
  "$CONFIG_SRC" > /usr/local/etc/xray/config.json

echo "Config written to /usr/local/etc/xray/config.json"

# Enable and start the service
systemctl enable xray
systemctl restart xray

echo "Xray service started."
echo ""
echo "Check status: systemctl status xray"
echo "Check logs:   journalctl -u xray -f"
