# Image #2: OpenClaw gateway, preconfigured for local Ollama + Discord.
# Full (non-slim) image so native dependencies (e.g. matrix-sdk-crypto) build.
FROM node:24-bookworm

# Install the OpenClaw CLI globally (recommended runtime is Node 24).
RUN npm install -g openclaw@latest

# Run as the built-in non-root `node` user; all state lives under its home.
USER node
ENV OPENCLAW_HOME=/home/node \
    OPENCLAW_STATE_DIR=/home/node/.openclaw \
    OPENCLAW_CONFIG_PATH=/home/node/.openclaw/openclaw.json

# Bake the default config in. On first run docker seeds the named volume with
# this file; later edits persist in the volume.
COPY --chown=node:node openclaw.json /home/node/.openclaw/openclaw.json

# Gateway HTTP/control port.
EXPOSE 18789

# `--bind lan` exposes the gateway beyond loopback so the host can reach it.
CMD ["openclaw", "gateway", "--bind", "lan", "--port", "18789"]
