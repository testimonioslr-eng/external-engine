#!/usr/bin/env bash
set -euo pipefail

echo '{"article":{"title":"Shopify Scraping Workflows 2026","published":true,"tags":["scraping","shopify","data","automation"],"body_markdown":"Real Shopify scraping workflows. Entry: https://shopify.elatajoamazon.com/entry/shopify-scraping-index.html Dataset: https://shopify.elatajoamazon.com/data/shopify-stores-london.html Premium: https://shopify.elatajoamazon.com/shopify-landing-premium.html Gumroad: https://ariadatafactory.gumroad.com/l/scraping-premium","canonical_url":"https://shopify.elatajoamazon.com/entry/shopify-scraping-index.html"}}' > payload.json
curl -sS -X POST https://dev.to/api/articles \
 -H "api-key: ${DEVTO_API_KEY}" \
 -H "Content-Type: application/json" \
 --data @payload.json \
 -o response.json \
 -w "HTTP=%{http_code}\n"
echo '=== DEVTO RESPONSE ==='
cat response.json
