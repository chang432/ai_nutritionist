#!/usr/bin/env bash
set -euo pipefail

# Model this image is responsible for. Overridable via the OLLAMA_MODEL env var.
OLLAMA_MODEL="${OLLAMA_MODEL:-qwen2.5:1.5b-instruct}"

# Start the Ollama server in the background so we can use its API to pull a model.
ollama serve &
server_pid=$!

# Block until the local API is responsive before issuing the pull.
echo "[entrypoint] waiting for the Ollama API to come up..."
until ollama ls >/dev/null 2>&1; do
  sleep 1
done

# Download + register the model. `ollama pull` is idempotent: when the model is
# already present in the mounted volume, existing layers are skipped immediately.
echo "[entrypoint] ensuring model '${OLLAMA_MODEL}' is available..."
ollama pull "${OLLAMA_MODEL}"

echo "[entrypoint] ready: serving '${OLLAMA_MODEL}' on 0.0.0.0:11434"

# Hand the foreground back to the long-running server so the container stays up
# and signals (SIGTERM on `docker stop`) reach it for a clean shutdown.
wait "$server_pid"
