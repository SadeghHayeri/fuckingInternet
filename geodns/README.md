# GeoDNS Guide

GeoDNS returns different IP addresses based on the user's geographic location.

## Options

| Provider | Real GeoDNS | Free | Ease |
|----------|-------------|------|------|
| [AWS Route53](route53/setup.md) | ✅ | ❌ (~$1/mo) | Medium |
| [Cloudflare LB](cloudflare/setup.md) | ✅ | ❌ (paid) | Easy |
| [Cloudflare Workers](cloudflare/setup.md) | Simulated | ✅ (limited) | Medium |
| NS1 | ✅ | ✅ (up to 500k queries/mo) | Medium |

## Recommendation

For production: **AWS Route53** with Health Checks.

For a quick test: **Cloudflare Workers**.
