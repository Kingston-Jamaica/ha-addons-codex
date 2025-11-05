#!/usr/bin/env bash
set -euo pipefail

# Read options provided by the add-on config
API_KEY="$(bashio::config 'api_key' || true)"
WORKDIR="$(bashio::config 'workdir')"

# Prepare working dir
mkdir -p "$WORKDIR"

# If an API key is provided, perform headless login (safe no-op if already logged in)
if [[ -n "${API_KEY:-}" ]]; then
  printf '%s' "$API_KEY" | codex login --with-api-key || true
fi

# Start a web terminal via Ingress; you'll run `codex` interactively there
exec ttyd -p 8099 -W -t titleFixed="Codex CLI" bash -lc "cd '$WORKDIR'; bash"
