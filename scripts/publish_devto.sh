#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "$0")/.."
for file in content/devto/*.md; do
 title=$(awk '/^title: /{sub(/^title: /,""); print; exit}' "$file")
 canonical=$(awk '/^canonical_url: /{sub(/^canonical_url: /,""); print; exit}' "$file")
 body=$(awk 'BEGIN{front=0; body=0} NR==1 && $0=="---" {front=1; next} front==1 && $0=="---" {front=0; body=1; next} body==1 {print}' "$file")
 safe_title=$(printf '%s' "$title" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read().strip()))')
 safe_canonical=$(printf '%s' "$canonical" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read().strip()))')
 safe_body=$(printf '%s' "$body" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')
 printf '{"article":{"title":%s,"published":true,"tags":["scraping","shopify","data","automation"],"body_markdown":%s,"canonical_url":%s}}' "$safe_title" "$safe_body" "$safe_canonical" > payload.json
 echo "=== FILE === $file"
 curl -sS -X POST https://dev.to/api/articles \
 -H "api-key: ${DEVTO_API_KEY}" \
 -H "Content-Type: application/json" \
 --data @payload.json \
 -o response.json \
 -w "HTTP=%{http_code}\n"
 echo '=== RESPONSE ==='
 head -c 1200 response.json || true
 echo
 sleep 90
done
