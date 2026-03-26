# Scripts

| Script | Purpose |
|--------|---------|
| `install-xray.sh` | Install Xray-core |
| `setup-iran-server.sh` | Full setup of the Iran server |
| `health-check.sh` | Check tunnel and site reachability |

## Example

```bash
# On the Iran server:
FOREIGN_SERVER_IP=1.2.3.4 MAIN_BACKEND_IP=5.6.7.8 \
  bash setup-iran-server.sh

# Check status:
bash health-check.sh yourdomain.com IRAN_IP FOREIGN_IP
```
