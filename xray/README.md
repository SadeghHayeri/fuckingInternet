# Xray Configuration

## Foreign server (`foreign-server/config.json`)

Opens a **vmess inbound** on port `10443` that the Iran server connects to.

Values to replace:
- `YOUR_VMESS_UUID` — generate a random UUID: `cat /proc/sys/kernel/random/uuid`

## Iran server (`iran-server/config.json`)

Accepts traffic on ports `53` (DNS), `4443` (HTTPS), and `8000` (HTTP) and routes it through a local socks proxy to the destination servers. Uses Xray's reverse bridge to maintain the tunnel.

Values to replace:
- `FOREIGN_SERVER_IP` — IP of the foreign/proxy server (used for DNS forwarding)
- `MAIN_BACKEND_IP` — IP of your main web backend server
- `vpn-access` outbound — paste your converted vmess/vless outbound JSON here (see comment in config)

## Running

```bash
# Install
bash ../../scripts/install-xray.sh

# Run with config
xray run -config config.json

# Or as a systemd service
cp config.json /usr/local/etc/xray/config.json
systemctl enable xray
systemctl start xray
```

## Testing the tunnel

```bash
# From the Iran server, verify it can reach the foreign server
curl -v --proxy socks5://127.0.0.1:10808 https://YOUR_DOMAIN.com
```
