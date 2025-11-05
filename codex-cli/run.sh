#!/usr/bin/env bash
set -euo pipefail

# Try to load bashio if present (HA add-on base provides it)
if [ -f /usr/lib/bashio/bashio.sh ]; then
  # shellcheck disable=SC1091
  . /usr/lib/bashio/bashio.sh
  API_KEY="$(bashio::config 'api_key' || true)"
  WORKDIR="$(bashio::config 'workdir' || echo '/config')"
else
  # Fallback: read options.json directly with jq
  if [ -f /data/options.json ]; then
    API_KEY="$(jq -r '.api_key // ""' /data/options.json)"
    WORKDIR="$(jq -r '.workdir // "/config"' /data/options.json)"
  else
    API_KEY=""
    WORKDIR="/config"
  fi
fi

# Ensure workdir exists
mkdir -p "$WORKDIR"

# If API key provided, perform headless sign-in (idempotent)
if [ -n "${API_KEY:-}" ]; then
  printf '%s' "$API_KEY" | codex login --with-api-key || true
fi

# Start a web terminal via Ingress on 8099 and land in $WORKDIR
exec ttyd -p 8099 -W -t titleFixed="Codex CLI" bash -lc "cd '$WORKDIR'; export PATH=\"\$PATH:$(npm bin -g)\"; bash"
