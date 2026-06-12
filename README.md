# OpenClaw + Ollama (Qwen2.5 1.5B Instruct)

A two-image Docker Compose stack:

| Service    | Image (built locally)                | What it does                                              |
| ---------- | ------------------------------------ | -------------------------------------------------------- |
| `ollama`   | `ai-nutritionist/ollama-qwen:latest` | Runs Ollama and pulls **Qwen2.5 1.5B Instruct** on boot. |
| `openclaw` | `ai-nutritionist/openclaw:latest`    | OpenClaw assistant, using the local model, chatting over **Discord**. |

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

These steps can't be automated — they require your Discord account:

1. **Create the bot** — Discord Developer Portal → New Application → Bot → Reset
   Token. Put the token in `.env` as `DISCORD_BOT_TOKEN`.
2. **Enable intents** (Bot → Privileged Gateway Intents):
   - Message Content Intent — **required**
   - Server Members Intent — recommended (role/user matching)
3. **Invite the bot** — OAuth2 → URL Generator → scopes `bot` and
   `applications.commands`; permissions: View Channels, Send Messages, Read
   Message History, Embed Links, Attach Files (+ Send Messages in Threads if used).
   Open the generated URL and add the bot to your server.
4. **Set the gateway token** — put a long random string in `.env` as
   `OPENCLAW_GATEWAY_TOKEN` (e.g. `openssl rand -hex 32`).

The Discord channel is enabled in `openclaw/openclaw.json` under `channels.discord`
with permissive DM/guild policies — tighten them for production.
