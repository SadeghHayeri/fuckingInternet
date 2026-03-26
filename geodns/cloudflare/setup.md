# GeoDNS با Cloudflare

Cloudflare پلن رایگانش GeoDNS نداره، ولی با **Load Balancing** (پولی) یا **Workers** (رایگان با محدودیت) میشه شبیه‌سازیش کرد.

---

## روش ۱: Cloudflare Load Balancing (پولی، ساده‌تر)

### ۱. Pool بسازید

وارد Cloudflare Dashboard شید:
`Traffic > Load Balancing > Manage Pools > Create Pool`

- **Pool ایران**: آی‌پی سرور ایران
- **Pool خارج**: آی‌پی سرور خارج

### ۲. Load Balancer بسازید

`Traffic > Load Balancing > Create Load Balancer`

- Hostname: `yourdomain.com`
- Default Pool: Pool خارج

### ۳. Geo Routing اضافه کنید

در تب **Geo Routing**:

| Region | Pool |
|--------|------|
| Iran (IR) | Pool ایران |
| Default | Pool خارج |

---

## روش ۲: Cloudflare Workers (رایگان)

یک Worker بسازید که بر اساس `cf.country` ریدایرکت کنه:

```javascript
export default {
  async fetch(request, env) {
    const country = request.cf?.country ?? 'XX';

    // آی‌پی‌ها رو اینجا بذارید
    const IRAN_SERVER = 'https://IRAN_SERVER_IP';
    const FOREIGN_SERVER = 'https://FOREIGN_SERVER_IP';

    const target = country === 'IR' ? IRAN_SERVER : FOREIGN_SERVER;

    // درخواست رو به سرور مناسب پاس بده
    const url = new URL(request.url);
    const targetUrl = target + url.pathname + url.search;

    return fetch(targetUrl, {
      method: request.method,
      headers: request.headers,
      body: request.body,
    });
  }
};
```

> **نکته**: این روش پروکسی هست نه DNS خالص — لیتنسی بیشتری داره.

---

## روش ۳: DNS جداگانه (توصیه شده برای پروداکشن)

به جای Cloudflare برای GeoDNS، از یه DNS provider که واقعاً GeoDNS داره استفاده کنید:

- **AWS Route53** — ببینید [../route53/setup.md](../route53/setup.md)
- **NS1** — رایگان تا ۵۰۰k query در ماه
- **DNSMadeEasy**

و Cloudflare رو فقط برای CDN/WAF روی هر دو سرور نگه دارید.
