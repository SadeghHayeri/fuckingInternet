# Xray Configuration

## Foreign server (`foreign-server/config.json`)

Opens a **vmess inbound** on port `10443` that the Iran server connects to.

Values to replace:
- `YOUR_VMESS_UUID` — generate a random UUID: `cat /proc/sys/kernel/random/uuid`

## Iran server (`iran-server/config.json`)

Accepts traffic on ports `80` and `443` and forwards it through a vmess tunnel to the foreign server.

Values to replace:
- `YOUR_VMESS_UUID` — same UUID as the foreign server
- `FOREIGN_SERVER_IP` — IP address of the foreign server

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
