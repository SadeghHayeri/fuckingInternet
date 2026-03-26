# Scripts

| اسکریپت | کاربرد |
|---------|--------|
| `install-xray.sh` | نصب Xray-core |
| `setup-iran-server.sh` | راه‌اندازی کامل سرور ایران |
| `health-check.sh` | چک وضعیت تانل و دسترس‌پذیری |

## مثال

```bash
# روی سرور ایران:
FOREIGN_SERVER_IP=1.2.3.4 VMESS_UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
  bash setup-iran-server.sh

# چک وضعیت:
bash health-check.sh yourdomain.com IRAN_IP FOREIGN_IP
```
