#!/usr/bin/env bash
# Routes every PentAGI agent role to gemini-2.0-flash via Gemini's OpenAI-compatible
# endpoint. The free tier of the heavy Gemini models returns 503 "high demand";
# flash has far more free capacity. Run after the stack is up, then restart.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT/pentagi"

KEY="$(grep -m1 '^GEMINI_API_KEY=' .env | cut -d= -f2- || true)"
if [ -z "$KEY" ]; then
  echo "خطا: GEMINI_API_KEY در pentagi/.env خالی است. اول کلید را در Codespaces Secrets بگذارید." >&2
  exit 1
fi

cp "$ROOT/config/gemini-flash.provider.yml" example.custom.provider.yml

set_var() {
  grep -v "^$1=" .env > .env.tmp || true
  printf '%s=%s\n' "$1" "$2" >> .env.tmp
  mv .env.tmp .env
}
set_var LLM_SERVER_URL "https://generativelanguage.googleapis.com/v1beta/openai"
set_var LLM_SERVER_KEY "$KEY"
set_var LLM_SERVER_MODEL "gemini-2.0-flash"
set_var LLM_SERVER_CONFIG_PATH "/opt/pentagi/conf/custom.provider.yml"

docker compose up -d
echo
echo "انجام شد. حالا در پنل یک Flow جدید بساز و از منوی مدل، پایین کادر پیام، گزینه 'custom' را انتخاب کن (نه gemini)."
