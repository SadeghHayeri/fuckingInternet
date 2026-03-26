# Dual-Access Website — GeoDNS + Xray

Make your website reachable from **both inside and outside Iran** on the same domain.

## How it works

```
                        ┌─────────────────────────────────────────────────────┐
                        │                  BIND9 (GeoDNS)                     │
                        │         runs on BOTH servers, same config           │
                        │                                                     │
                        │  Iranian resolver ──► iran view ──► Iran server IP  │
                        │  Global resolver  ──► default view ──► Foreign IP   │
                        └─────────────────────────────────────────────────────┘
                                  ▲                        ▲
                                  │                        │
                            ns2 (Iran)               ns1 (Foreign)
                          (Iran server IP)         (Foreign server IP)


Iranian user                                        Foreign user
     │                                                   │
     │ DNS query → returns Iran server IP                │ DNS query → returns Foreign server IP
     ▼                                                   ▼
Iran server                                        Foreign server
  (Nginx)                                          (main backend)
     │
     │ Xray tunnel (vmess/vless)
     ▼
Foreign server
  (main backend)
```

Both users reach the same backend — Iranian users go through the Iran server as a tunnel.

## Prerequisites

- A server **inside Iran** (Arvan Cloud, Parspack, etc.)
- A server **outside Iran** (your main server)
- A **vmess/vless config** to tunnel between them
- A domain

## Setup

### 1. Xray — Iran server

Place `xray/iran-server/config.json` on the Iran server and replace:

| Placeholder | Value |
|-------------|-------|
| `FOREIGN_SERVER_IP` | IP of your foreign server |
| `MAIN_BACKEND_IP` | IP of your main web backend |
| `vpn-access` outbound | your vmess/vless outbound JSON (see comment in file) |

See [xray/README.md](xray/README.md).

### 2. Nginx — Iran server

Place `nginx/iran-server.conf` on the Iran server and replace `YOUR_DOMAIN`.

Get an SSL cert: `certbot --nginx -d YOUR_DOMAIN`

See [nginx/README.md](nginx/README.md).

### 3. GeoDNS — both servers

Deploy BIND9 on both servers via Docker and point your domain's NS records at them:

```
ns1.YOUR_DOMAIN  →  Foreign server IP
ns2.YOUR_DOMAIN  →  Iran server IP
```

See [geodns/bind/README.md](geodns/bind/README.md).

## Repo Structure

```
.
├── xray/
│   └── iran-server/config.json    # Port-forwarding via vmess/vless tunnel
├── nginx/
│   ├── nginx.conf                 # Cache zone + log format
│   └── iran-server.conf           # Reverse proxy with caching
└── geodns/
    ├── compose.yaml               # Docker Compose for BIND9
    └── bind/
        ├── named.conf.local       # iran / default views
        ├── acl/iran.acl           # Iranian IP ranges
        └── zones/                 # Zone files (global + iran)
```

## Notes

- The Iran server is a **tunnel only** — all real load stays on the foreign server
- SSL must be set up on the Iran server (nginx terminates it before forwarding)
- The BIND ACL (`acl/iran.acl`) needs periodic updates as Iranian IP ranges change
