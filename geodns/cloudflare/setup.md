# GeoDNS with Cloudflare

Cloudflare's free plan does not support GeoDNS, but you can simulate it with **Load Balancing** (paid) or **Workers** (free with limits).

---

## Option 1: Cloudflare Load Balancing (paid, simplest)

### 1. Create pools

Go to Cloudflare Dashboard:
`Traffic > Load Balancing > Manage Pools > Create Pool`

- **Iran pool**: Iran server IP
- **Foreign pool**: Foreign server IP

### 2. Create a Load Balancer

`Traffic > Load Balancing > Create Load Balancer`

- Hostname: `yourdomain.com`
- Default Pool: Foreign pool

### 3. Add Geo Routing

Under the **Geo Routing** tab:

| Region | Pool |
|--------|------|
| Iran (IR) | Iran pool |
| Default | Foreign pool |

---

## Option 2: Cloudflare Workers (free)

Create a Worker that proxies based on `cf.country`:

```javascript
export default {
  async fetch(request, env) {
    const country = request.cf?.country ?? 'XX';

    const IRAN_SERVER = 'https://IRAN_SERVER_IP';
    const FOREIGN_SERVER = 'https://FOREIGN_SERVER_IP';

    const target = country === 'IR' ? IRAN_SERVER : FOREIGN_SERVER;

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

> **Note**: This is a proxy, not pure DNS — it adds latency compared to a real GeoDNS solution.

---

## Option 3: Dedicated GeoDNS provider (recommended for production)

Use a DNS provider with native GeoDNS support instead of Cloudflare for routing:

- **AWS Route53** — see [../route53/setup.md](../route53/setup.md)
- **NS1** — free up to 500k queries/month
- **DNSMadeEasy**

Keep Cloudflare only for CDN/WAF in front of each server.
