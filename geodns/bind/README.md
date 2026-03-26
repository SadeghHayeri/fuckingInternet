# BIND GeoDNS

Runs BIND9 in Docker. Serves different DNS responses based on whether the querying resolver comes from an Iranian IP range.

## How it works

```
Iranian resolver
    │
    ▼
BIND (iran view — matched by ACL)
    │
    ▼
Returns IRAN_SERVER_IP for @ and *


Global resolver
    │
    ▼
BIND (default view — catch-all)
    │
    ▼
Returns GLOBAL_SERVER_IP for @ and *
```

Both your Iran server and your global server run the **exact same BIND config**. The ACL in `acl/iran.acl` detects Iranian resolver IPs and routes them to the iran view automatically, regardless of which nameserver they query.

## Files

```
bind/
├── named.conf                  # Entry point — includes the other files
├── named.conf.options          # Global options (listen, recursion, dnssec)
├── named.conf.local            # Views and zone definitions
├── named.conf.logging          # Log queries to stderr (Docker-friendly)
├── acl/
│   └── iran.acl                # List of Iranian IP ranges
└── zones/
    ├── db.YOUR_DOMAIN.global   # Zone served to global users
    └── db.YOUR_DOMAIN.iran     # Zone served to Iranian users
```

## Setup

### 1. Rename zone files

```bash
cp zones/db.YOUR_DOMAIN.global zones/db.example.com.global
cp zones/db.YOUR_DOMAIN.iran   zones/db.example.com.iran
```

### 2. Replace placeholders

In `named.conf.local` and both zone files replace:

| Placeholder | Value |
|-------------|-------|
| `YOUR_DOMAIN` | your domain, e.g. `example.com` |
| `NS1_IP` | global server IP (this server's public IP when deployed globally) |
| `NS2_IP` | Iran server IP (this server's public IP when deployed in Iran) |
| `GLOBAL_SERVER_IP` | IP returned to global users (usually same as NS1_IP) |
| `IRAN_SERVER_IP` | IP returned to Iranian users (usually same as NS2_IP) |

### 3. Start BIND

```bash
# From the geodns/ directory
docker compose up -d
```

### 4. Set NS records at your domain registrar

This is the critical step. Go to your domain registrar and set the nameservers to:

```
ns1.YOUR_DOMAIN  →  NS1_IP   (your global server)
ns2.YOUR_DOMAIN  →  NS2_IP   (your Iran server)
```

Most registrars call these **glue records** — you register the NS hostnames together with their IPs because they live under the same domain they're serving.

Once propagated, global resolvers will query BIND and get `GLOBAL_SERVER_IP`, and Iranian resolvers will get `IRAN_SERVER_IP`.

## Updating the Iranian IP list

`acl/iran.acl` contains a starter set of Iranian IP ranges. These change over time. Update from a current source such as:

```bash
# RIPE NCC — fetch all prefixes allocated to IR
whois -h whois.ripe.net -- '-i origin $(whois -h whois.ripe.net IR | grep "aut-num" | ...)'
```

Or use a maintained list like [ipverse/rir-ip](https://github.com/ipverse/rir-ip).

After updating, reload BIND:

```bash
docker compose exec bind9 rndc reload
```

## Testing

```bash
# Should return GLOBAL_SERVER_IP
dig YOUR_DOMAIN @NS1_IP

# Should return IRAN_SERVER_IP (query from an Iranian IP, or spoof with a test client)
dig YOUR_DOMAIN @NS2_IP
```
