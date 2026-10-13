#!/usr/bin/env bash
# Morgonbrief: sammanfattar de senaste 7 daily-anteckningarna + inbox.md
# till vault/briefs/YYYY-MM-DD.md via Luna (lokal Ollama).
#
# Körs av launchd (se.aikollegorna.luna.morning) varje hel timme. Jobbet görs
# bara när klockan är 07 i Europe/Stockholm och dagens brief saknas — Macens
# systemklocka kan stå i en annan tidszon (just nu US/Pacific), så schemat
# får inte lita på systemtidens timme. Kör med --force för att köra direkt.
set -euo pipefail

LUNA_ROOT="${LUNA_ROOT:-$HOME/Code/luna}"
VAULT="$LUNA_ROOT/vault"
BRIEFS="$VAULT/briefs"
TODAY="$(TZ=Europe/Stockholm date +%Y-%m-%d)"
HOUR="$(TZ=Europe/Stockholm date +%H)"
BRIEF_FILE="$BRIEFS/$TODAY.md"

if [[ "${1:-}" != "--force" ]]; then
  [[ "$HOUR" == "07" ]] || exit 0
fi
if [[ -f "$BRIEF_FILE" ]]; then
  echo "[morning-brief] $BRIEF_FILE finns redan — hoppar över."
  exit 0
fi

mkdir -p "$BRIEFS"

# Samla underlaget deterministiskt här i skriptet (den lilla modellen ska
# sammanfatta, inte leta filer): de 7 senaste daily-filerna + inbox.md.
material="$(
  for f in $(ls "$VAULT"/daily/*.md 2>/dev/null | sort | tail -7); do
    printf -- '--- %s ---\n' "$(basename "$f")"
    cat "$f"
    printf '\n'
  done
  printf -- '--- inbox.md ---\n'
  cat "$VAULT/inbox.md" 2>/dev/null || true
)"

prompt="Skriv dagens morgonbrief. Använd write_file och skriv filen $BRIEF_FILE med exakt denna struktur:

# Morgonbrief $TODAY

## Öppna punkter
## Personer att följa upp
## På gång

Kort svenska, punktlistor, max 10 rader totalt. Basera dig ENBART på underlaget nedan — hitta inte på något. Svara sedan bara 'Klart'.

UNDERLAG:
$material"

echo "[morning-brief] $(date '+%Y-%m-%d %H:%M:%S %Z') skriver $BRIEF_FILE"
"$LUNA_ROOT/hermes/luna" chat -q "$prompt"

if [[ -f "$BRIEF_FILE" ]]; then
  echo "[morning-brief] OK: $BRIEF_FILE"
else
  echo "[morning-brief] FEL: $BRIEF_FILE skrevs aldrig" >&2
  exit 1
fi
