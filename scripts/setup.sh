#!/usr/bin/env bash
# Downloads PentAGI's compose files and builds pentagi/.env from Codespaces secrets.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIR="$ROOT/pentagi"
RAW="https://raw.githubusercontent.com/vxcontrol/pentagi/main"
mkdir -p "$DIR"
cd "$DIR"

curl -fsSL -o docker-compose.yml "$RAW/docker-compose.yml"
curl -fsSL -o example.custom.provider.yml "$RAW/examples/configs/custom-openai.provider.yml"
curl -fsSL -o example.ollama.provider.yml "$RAW/examples/configs/ollama-llama318b.provider.yml"
curl -fsSL -o example.bedrock.provider.yml "$RAW/examples/configs/bedrock.provider.yml"

set_var() { # set_var NAME VALUE  -> replaces or appends NAME=VALUE in .env
  grep -v "^$1=" .env > .env.tmp || true
  printf '%s=%s\n' "$1" "$2" >> .env.tmp
  mv .env.tmp .env
}
rand() { openssl rand -hex 16; }

# Create .env once, with random passwords (databases keep the first password).
if [ ! -f .env ]; then
  curl -fsSL -o .env "$RAW/.env.example"
  set_var COOKIE_SIGNING_SALT "$(rand)"
  set_var PENTAGI_POSTGRES_PASSWORD "$(rand)"
  set_var NEO4J_PASSWORD "$(rand)"
fi

# Public URL of the forwarded port, so login cookies and CORS work in Codespaces.
if [ -n "${CODESPACE_NAME:-}" ]; then
  URL="https://${CODESPACE_NAME}-8443.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN:-app.github.dev}"
  set_var PUBLIC_URL "$URL"
  set_var CORS_ORIGINS "$URL,https://localhost:8443"
fi

# Copy any LLM keys stored as Codespaces secrets into .env.
found=0
for k in OPEN_AI_KEY ANTHROPIC_API_KEY GEMINI_API_KEY DEEPSEEK_API_KEY; do
  if [ -n "${!k:-}" ]; then set_var "$k" "${!k}"; found=1; fi
done
if [ "$found" = 0 ]; then
  echo "هشدار: هیچ کلید API پیدا نشد. یکی را در Codespaces Secrets بگذارید یا در pentagi/.env بنویسید." >&2
fi
echo "PentAGI setup done: $DIR"
