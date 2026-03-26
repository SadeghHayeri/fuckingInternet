# GeoDNS

GeoDNS returns different IP addresses based on the user's geographic location. This repo uses a **self-hosted BIND9** setup as the primary approach, so you control everything and don't pay per-query.

## How NS delegation works

Instead of using Cloudflare or Route53 as your nameserver, you point your domain's NS records directly to your own two servers:

```
Registrar NS records:
  ns1.YOUR_DOMAIN  →  NS1_IP  (global server)
  ns2.YOUR_DOMAIN  →  NS2_IP  (Iran server)
```

Both servers run the same BIND config. BIND has two views:
- **iran view** — matched by an IP ACL of Iranian ranges → returns Iran server IP
- **default view** — everyone else → returns global server IP

See [bind/README.md](bind/README.md) for full setup instructions.

## Alternatives

If you don't want to self-host DNS:

| Provider | GeoDNS | Free | Notes |
|----------|--------|------|-------|
| [AWS Route53](route53/setup.md) | ✅ | ❌ (~$1/mo) | Geolocation routing built-in |
| [Cloudflare LB](cloudflare/setup.md) | ✅ | ❌ (paid) | Easy UI |
| [Cloudflare Workers](cloudflare/setup.md) | Simulated | ✅ (limited) | Proxy-based, adds latency |
| NS1 | ✅ | ✅ (up to 500k/mo) | Good free tier |
