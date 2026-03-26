# Nginx Configuration

## `nginx.conf`

Main nginx config. Defines the `cdn_cache` proxy cache zone used by the site config, custom upstream log format, and includes site configs from `sites-enabled/`.

Copy to `/etc/nginx/nginx.conf`.

## `iran-server.conf`

Reverse proxy with caching. Sits in front of Xray's port-forwarded backend (`127.0.0.1:8000`).

### Values to replace

- `YOUR_DOMAIN` — your actual domain (e.g. `example.com`)

### Setup

```bash
# Replace YOUR_DOMAIN and copy to nginx
sed 's/YOUR_DOMAIN/example.com/g' iran-server.conf \
  > /etc/nginx/sites-available/example.com

ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/

# Create the cache zone (add to /etc/nginx/nginx.conf inside the http block)
# proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=cdn_cache:10m max_size=1g inactive=60m use_temp_path=off;

nginx -t && systemctl reload nginx
```

### Cache zone

The config references a `cdn_cache` zone that must be declared in your `nginx.conf` `http` block:

```nginx
proxy_cache_path /var/cache/nginx
                 levels=1:2
                 keys_zone=cdn_cache:10m
                 max_size=1g
                 inactive=60m
                 use_temp_path=off;
```

### SSL

Get a certificate via Certbot:

```bash
certbot --nginx -d YOUR_DOMAIN
```
