#!/usr/bin/env bash
set -euo pipefail

echo "[codex-cli] run.sh starting: $(date -Iseconds)"

# Try to load bashio if present
if [ -f /usr/lib/bashio/bashio.sh ]; then
  # shellcheck disable=SC1091
  . /usr/lib/bashio/bashio.sh || true
  if type -t bashio::config >/dev/null 2>&1; then
    API_KEY="$(bashio::config 'api_key' || true)"
    WORKDIR="$(bashio::config 'workdir' || echo '/config')"
    echo "[codex-cli] bashio loaded. workdir=${WORKDIR}"
  else
    echo "[codex-cli] bashio not functional; falling back to /data/options.json"
    API_KEY="$(jq -r '.api_key // ""' /data/options.json 2>/dev/null || echo '')"
    WORKDIR="$(jq -r '.workdir // "/config"' /data/options.json 2>/dev/null || echo '/config')"
  fi
else
  echo "[codex-cli] /usr/lib/bashio/bashio.sh not found; falling back to /data/options.json"
  API_KEY="$(jq -r '.api_key // ""' /data/options.json 2>/dev/null || echo '')"
  WORKDIR="$(jq -r '.workdir // "/config"' /data/options.json 2>/dev/null || echo '/config')"
fi

# Ensure workdir exists
mkdir -p "$WORKDIR"

# Headless login if API key provided (idempotent)
if [ -n "${API_KEY:-}" ]; then
  printf '%s' "$API_KEY" | codex login --with-api-key || true
fi

echo "[codex-cli] launching ttyd at workdir: $WORKDIR"
exec ttyd -p 8099 -W -t titleFixed="Codex CLI" bash -lc "cd '$WORKDIR'; export PATH=\"\$PATH:$(npm bin -g)\"; bash"
