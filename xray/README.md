# Xray Configuration

## سرور خارج (`foreign-server/config.json`)

یک **inbound vmess** روی پورت `10443` باز می‌کنه که سرور ایران بهش وصل می‌شه.

مقادیری که باید عوض کنید:
- `YOUR_VMESS_UUID` — یک UUID تصادفی بسازید: `cat /proc/sys/kernel/random/uuid`

## سرور ایران (`iran-server/config.json`)

پورت‌های `80` و `443` رو می‌گیره و از طریق تانل vmess به سرور خارج می‌فرسته.

مقادیری که باید عوض کنید:
- `YOUR_VMESS_UUID` — همون UUID سرور خارج
- `FOREIGN_SERVER_IP` — آی‌پی سرور خارج

## اجرا

```bash
# نصب
bash ../../scripts/install-xray.sh

# اجرا با کانفیگ
xray run -config config.json

# یا به عنوان سرویس systemd
cp config.json /usr/local/etc/xray/config.json
systemctl enable xray
systemctl start xray
```

## تست تانل

```bash
# از سرور ایران، چک کن که به سرور خارج وصل میشه
curl -v --proxy socks5://127.0.0.1:10808 https://YOUR_DOMAIN.com
```
