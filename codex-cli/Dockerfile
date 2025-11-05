ARG BUILD_FROM
FROM ${BUILD_FROM}

# Install deps: nodejs, npm, ttyd, git, curl, certs
RUN apk add --no-cache bash nodejs npm ttyd git curl ca-certificates

# Install Codex CLI globally
RUN npm i -g @openai/codex

# Ensure npm global bin is on PATH
ENV PATH="${PATH}:$(npm bin -g)"

# Runner script
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
