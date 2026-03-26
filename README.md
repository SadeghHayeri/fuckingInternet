# fuckingInternet - GeoDNS + Xray Guide

How to make your website accessible from **both inside and outside Iran** using GeoDNS and Xray.

---

## The Problem

Two common scenarios:

1. **Server is outside Iran** — Iranian users can't reach it due to filtering
2. **Server is inside Iran** — international users can't reach it due to sanctions

Goal: both groups access the site on the **same domain**.

---

## Architecture

```
Iranian user
    │
    ▼
DNS → Iran server IP
    │
    ▼
Iran server  ──── Xray tunnel ────►  Foreign server (main)
    │                                        │
    └── port forward ────────────────────────┘
                                      main backend


Foreign user
    │
    ▼
DNS → Foreign server IP (main)
    │
    ▼
Foreign server (main)
```

GeoDNS returns different IPs based on the user's location. Both IPs eventually reach the same backend.

---

## Prerequisites

- A server **inside Iran** (e.g. Arvan Cloud, Parspack, etc.)
- A server **outside Iran** (your main server)
- A **vmess/vless config** for tunneling between the two servers
- A **DNS provider** with GeoDNS support (Cloudflare, AWS Route53, etc.)

---

## Repo Structure

```
.
├── README.md
├── xray/
│   ├── README.md
│   ├── iran-server/
│   │   └── config.json          # Xray config for Iran server (outbound tunnel)
│   └── foreign-server/
│       └── config.json          # Xray config for foreign server (inbound)
├── nginx/
│   ├── README.md
│   ├── nginx.conf               # Main nginx config (cache zone, log format)
│   └── iran-server.conf         # Nginx reverse proxy with caching
├── geodns/
│   ├── README.md
│   ├── cloudflare/
│   │   └── setup.md             # GeoDNS setup with Cloudflare
│   └── route53/
│       └── setup.md             # GeoDNS setup with AWS Route53
└── scripts/
    ├── README.md
    ├── install-xray.sh          # Install Xray
    ├── setup-iran-server.sh     # Set up the Iran server
    └── health-check.sh          # Check tunnel status
```

---

## Setup Steps

### 1. Install Xray
```bash
bash scripts/install-xray.sh
```

### 2. Set up the foreign server (main)
Place `xray/foreign-server/config.json` on the foreign server and run Xray.

### 3. Set up the Iran server
Place `xray/iran-server/config.json` on the Iran server.
Replace the following values:
- `YOUR_VMESS_UUID` — the UUID from your vmess/vless config
- `FOREIGN_SERVER_IP` — IP address of the foreign server

### 4. Set up GeoDNS
Pick your DNS provider:
- [Cloudflare](geodns/cloudflare/setup.md)
- [AWS Route53](geodns/route53/setup.md)

---

## Important Notes

- This is **port forwarding**, not a traditional proxy — it adds some latency
- The Iran server is only a tunnel; all real load stays on the foreign server
- SSL must be configured on **both servers** (or use a wildcard cert)
- The Iran server only needs Xray — no nginx/apache required

---

## Contributing

Open a PR or an issue. Contributions welcome.
