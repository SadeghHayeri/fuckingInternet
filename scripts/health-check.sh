#!/bin/bash
# Check tunnel status and site reachability

DOMAIN="${1:-}"
IRAN_IP="${2:-}"
FOREIGN_IP="${3:-}"

if [[ -z "$DOMAIN" ]]; then
  echo "Usage: bash health-check.sh yourdomain.com IRAN_IP FOREIGN_IP"
  exit 1
fi

ok() { echo "  [OK] $1"; }
fail() { echo "  [FAIL] $1"; }

echo "=== Xray Service ==="
if systemctl is-active --quiet xray 2>/dev/null; then
  ok "xray is running"
else
  fail "xray is NOT running (run: systemctl status xray)"
fi

echo ""
echo "=== DNS Check ==="
RESOLVED=$(dig +short "$DOMAIN" 2>/dev/null | head -1)
echo "  $DOMAIN resolves to: ${RESOLVED:-FAILED}"

echo ""
echo "=== HTTP Reachability ==="

check_http() {
  local label="$1"
  local ip="$2"
  if curl -sk --max-time 5 -o /dev/null -w "%{http_code}" \
      -H "Host: $DOMAIN" "https://$ip/" | grep -qE "^[23]"; then
    ok "$label ($ip) — reachable"
  else
    fail "$label ($ip) — NOT reachable"
  fi
}

[[ -n "$IRAN_IP" ]]    && check_http "Iran server"    "$IRAN_IP"
[[ -n "$FOREIGN_IP" ]] && check_http "Foreign server" "$FOREIGN_IP"

echo ""
echo "=== Port Forward Test (from this machine) ==="
if curl -sk --max-time 5 -o /dev/null "https://$DOMAIN/"; then
  ok "$DOMAIN is reachable"
else
  fail "$DOMAIN is NOT reachable from this machine"
fi
