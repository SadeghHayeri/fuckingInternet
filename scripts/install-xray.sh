#!/bin/bash
# نصب Xray-core روی لینوکس

set -e

echo "Installing Xray-core..."

bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install

echo "Xray installed: $(xray version | head -1)"
echo ""
echo "Next steps:"
echo "  1. Put your config.json in /usr/local/etc/xray/config.json"
echo "  2. systemctl enable xray && systemctl start xray"
