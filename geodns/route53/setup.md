# GeoDNS با AWS Route53

Route53 از **Geolocation Routing** پشتیبانی می‌کنه — دقیقاً همین چیزیه که نیاز داریم.

---

## ۱. Hosted Zone بسازید

اگه دامنه‌تون جای دیگه‌ایه، یا NS رو به Route53 پوینت کنید یا از روش Delegation استفاده کنید.

```
AWS Console > Route53 > Hosted Zones > Create Hosted Zone
Domain: yourdomain.com
Type: Public
```

---

## ۲. رکورد برای سرور ایران

```
Route53 > yourdomain.com > Create Record

Name: yourdomain.com (یا @ برای root)
Type: A
Value: IRAN_SERVER_IP
TTL: 60

Routing Policy: Geolocation
Location: Islamic Republic of Iran
Record ID: iran-record
```

---

## ۳. رکورد پیش‌فرض (خارج)

```
Name: yourdomain.com
Type: A
Value: FOREIGN_SERVER_IP
TTL: 60

Routing Policy: Geolocation
Location: Default (همه جاهای دیگه)
Record ID: default-record
```

---

## ۴. Health Check (اختیاری ولی توصیه می‌شه)

اگه یه سرور down شد، Route53 ترافیک رو به اون نفرسته:

```
Route53 > Health Checks > Create Health Check

Name: iran-server-health
Monitor: Endpoint
Protocol: HTTPS
Domain: IRAN_SERVER_IP
Port: 443
Path: /health
```

همین رو برای سرور خارج هم بسازید، بعد به هر رکورد health check مربوطه رو assign کنید.

---

## ۵. تست

```bash
# چک کن از ایران چه آی‌پی برمی‌گرده
# (با یه VPN ایران تست کن)
dig yourdomain.com @8.8.8.8

# تست مستقیم
curl -H "Host: yourdomain.com" https://IRAN_SERVER_IP/
curl -H "Host: yourdomain.com" https://FOREIGN_SERVER_IP/
```

---

## هزینه

- Hosted Zone: ~$0.50/ماه
- Geolocation queries: ~$0.70 per million queries
- Health Checks: ~$0.50/ماه هر چک
