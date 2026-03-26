# GeoDNS with AWS Route53

Route53 supports **Geolocation Routing** natively — exactly what we need.

---

## 1. Create a Hosted Zone

If your domain is registered elsewhere, either point the NS records to Route53 or use delegation.

```
AWS Console > Route53 > Hosted Zones > Create Hosted Zone
Domain: yourdomain.com
Type: Public
```

---

## 2. Record for the Iran server

```
Route53 > yourdomain.com > Create Record

Name: yourdomain.com (or @ for root)
Type: A
Value: IRAN_SERVER_IP
TTL: 60

Routing Policy: Geolocation
Location: Islamic Republic of Iran
Record ID: iran-record
```

---

## 3. Default record (everyone else)

```
Name: yourdomain.com
Type: A
Value: FOREIGN_SERVER_IP
TTL: 60

Routing Policy: Geolocation
Location: Default
Record ID: default-record
```

---

## 4. Health Checks (optional but recommended)

If a server goes down, Route53 will stop sending traffic to it:

```
Route53 > Health Checks > Create Health Check

Name: iran-server-health
Monitor: Endpoint
Protocol: HTTPS
Domain: IRAN_SERVER_IP
Port: 443
Path: /health
```

Create the same for the foreign server, then assign each health check to its corresponding DNS record.

---

## 5. Testing

```bash
# Check which IP is returned (test with an Iranian VPN for the Iran record)
dig yourdomain.com @8.8.8.8

# Direct reachability test
curl -H "Host: yourdomain.com" https://IRAN_SERVER_IP/
curl -H "Host: yourdomain.com" https://FOREIGN_SERVER_IP/
```

---

## Cost

- Hosted Zone: ~$0.50/month
- Geolocation queries: ~$0.70 per million queries
- Health Checks: ~$0.50/month each
