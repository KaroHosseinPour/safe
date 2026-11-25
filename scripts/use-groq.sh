#!/usr/bin/env bash
# Routes PentAGI to Groq's free, fast OpenAI-compatible API (Llama models).
# Usage: bash scripts/use-groq.sh <GROQ_API_KEY>
#   or set GROQ_API_KEY as a Codespaces secret and run with no argument.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT/pentagi"

KEY="${1:-${GROQ_API_KEY:-}}"
if [ -z "$KEY" ]; then
  echo "خطا: کلید Groq را بده. مثل: bash scripts/use-groq.sh gsk_xxx" >&2
  exit 1
fi

cp "$ROOT/config/groq.provider.yml" example.custom.provider.yml

set_var() {
  grep -v "^$1=" .env > .env.tmp || true
  printf '%s=%s\n' "$1" "$2" >> .env.tmp
  mv .env.tmp .env
}
set_var LLM_SERVER_URL "https://api.groq.com/openai/v1"
set_var LLM_SERVER_KEY "$KEY"
set_var LLM_SERVER_MODEL "llama-3.3-70b-versatile"
set_var LLM_SERVER_CONFIG_PATH "/opt/pentagi/conf/custom.provider.yml"

docker compose up -d
echo
echo "انجام شد. در پنل یک Flow جدید بساز و از منوی مدل گزینه 'custom' را انتخاب کن."
