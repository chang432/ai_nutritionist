# OpenClaw + Ollama (Qwen2.5 1.5B Instruct)

A two-image Docker Compose stack:

| Service    | Image (built locally)                | What it does                                              |
| ---------- | ------------------------------------ | -------------------------------------------------------- |
| `ollama`   | `ai-nutritionist/ollama-qwen:latest` | Runs Ollama and pulls **Qwen2.5 1.5B Instruct** on boot. |
| `openclaw` | `ai-nutritionist/openclaw:latest`    | OpenClaw assistant, using the local model, chatting over **WhatsApp**. |

OpenClaw is preconfigured (`openclaw/openclaw.json`) to use `ollama/qwen2.5:1.5b-instruct`
as its default agent model via the native Ollama API at `http://ollama:11434`.

## Quick start

```bash
cp .env.example .env          # then fill in the two tokens (see below)
docker compose up --build
```

First boot downloads the Ollama base image and the Qwen model (~1 GB), so it takes
a few minutes. The model is cached in the `ollama-models` volume thereafter.

- OpenClaw gateway: `http://localhost:18789` (auth with `OPENCLAW_GATEWAY_TOKEN`)
- Ollama API: `http://localhost:11434`

To change the model, edit `OLLAMA_MODEL` in `docker-compose.yml` **and** the
`models`/`agents` entries in `openclaw/openclaw.json`.

## Manual Setup Required From Owner

WhatsApp links via **QR-code pairing** (WhatsApp Web), so there's no token to
create — but you must scan a code with the phone whose number the bot will use:

1. **Set the gateway token** — put a long random string in `.env` as
   `OPENCLAW_GATEWAY_TOKEN` (e.g. `openssl rand -hex 32`).
2. **Start the stack** — `docker compose up --build`.
3. **Link WhatsApp** — run the login command and scan the printed QR:
   ```bash
   docker compose exec openclaw openclaw channels login --channel whatsapp
   ```
   On your phone: WhatsApp → Settings → **Linked Devices** → Link a Device →
   scan the QR shown in the terminal.

Auth is stored at `~/.openclaw/credentials/whatsapp/` inside the `openclaw-state`
volume, so you only pair once — it survives restarts.

The WhatsApp channel is enabled in `openclaw/openclaw.json` under
`channels.whatsapp` with `dmPolicy: "pairing"`. To restrict who can talk to it,
switch to `dmPolicy: "allowlist"` and add numbers under `allowFrom`
(E.164 format, e.g. `"+15551234567"`).
