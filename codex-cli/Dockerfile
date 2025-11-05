ARG BUILD_FROM
FROM ${BUILD_FROM}

# Tools: bash, bashio (read /data/options.json), jq, nodejs, npm, ttyd, git, curl
RUN apk add --no-cache \
      bash bashio jq \
      nodejs npm ttyd git curl ca-certificates

# Install Codex CLI globally
RUN npm i -g @openai/codex

# Ensure npm global bin is on PATH
ENV PATH="${PATH}:$(npm bin -g)"

# Runner
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
