# Image #1: Ollama runtime that downloads and serves Qwen2.5 1.5B Instruct.
FROM ollama/ollama:latest

# Default model pulled on first boot (into the mounted volume). Override at
# build time with --build-arg or at run time with the OLLAMA_MODEL env var.
ENV OLLAMA_MODEL="qwen2.5:1.5b-instruct"

# Wrapper entrypoint: start the server, pull the model, then keep serving.
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Native Ollama API. (Do NOT use the /v1 OpenAI-compat path with OpenClaw;
# tool-calling is unreliable there.)
EXPOSE 11434

# Replace the base image's bare `ollama` entrypoint with our pull-then-serve wrapper.
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
