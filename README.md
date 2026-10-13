# Luna

Hermes + Ollama (`qwen3:8b`) + Obsidian-vault. Allt körs lokalt — inga moln-API-nycklar.

- `vault/` — Obsidian-vault (öppna den här mappen i Obsidian): `daily/`, `people/`, `projects/`, `briefs/`, `inbox.md`
- `hermes/` — Lunas Hermes-hem: `SOUL.md`, `config.yaml`, wrappern `luna`, `luna-note`, `morning-brief.sh`
- `hermes/hermes-agent/` — Nous Research Hermes Agent (installeras lokalt, committas inte)

## Starta

```bash
source ~/.zshrc   # första gången, så att `hermes` och `luna` finns på PATH
luna              # interaktiv CLI mot vaulten
luna chat -q "Anteckna att jag ska ringa Jakob på måndag"
```

`luna` sätter `HERMES_HOME=~/Code/luna/hermes`, startar i `vault/` och kopplar bort molnnycklar från skalet.

Modell: lokal Ollama `qwen3:8b` på `http://localhost:11434/v1`.

## Datum

Dagens datum kommer alltid från systemklockan, aldrig från modellen:

- Wrappern `luna` räknar ut datumet i **Europe/Stockholm** (Macens systemklocka står i US/Pacific!) och skriver raden `Dagens datum är YYYY-MM-DD (veckodag)` till `AGENTS.override.md` i repo-roten vid varje start. Hermes läser den filen in i systemprompten (AGENTS.md-kedjan git-rot → cwd); filen är gitignorerad.
- Wrappern sätter även `HERMES_TIMEZONE=Europe/Stockholm`.
- Alla anteckningar skrivs via `hermes/luna-note`, som själv stämplar datum från systemklockan och bara **appendar** (kan aldrig skriva över vaultfiler):

```bash
hermes/luna-note daily "Ringa [[Jakob]]"
hermes/luna-note people tobias "Vad som sas"
hermes/luna-note projects aktieagaravtal "Vad som hänt"
```

## Morgonbrief

`hermes/morning-brief.sh` sammanfattar de 7 senaste daily-filerna + `inbox.md` till `vault/briefs/YYYY-MM-DD.md` (max 10 rader svenska: öppna punkter, personer att följa upp, på gång).

- Schemalagd via launchd: `~/Library/LaunchAgents/se.aikollegorna.luna.morning.plist`. Agenten väcks **varje hel timme** men skriptet gör bara jobbet när klockan är **07 i Europe/Stockholm** och dagens brief saknas — launchd går på systemtid och Macen står i US/Pacific, så ett rakt `Hour 7` hade fyrat kl 16 svensk tid.
- Kör manuellt: `bash hermes/morning-brief.sh --force`
- Ladda om schemat efter ändring:

```bash
launchctl bootout gui/$(id -u)/se.aikollegorna.luna.morning 2>/dev/null
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/se.aikollegorna.luna.morning.plist
```

## Loggar

- Morgonbrief (launchd stdout/stderr): `hermes/logs/morning-brief.log`
- Hermes agent: `hermes/logs/agent.log`, `hermes/logs/errors.log` (eller `luna logs --follow`)

## Kontextfönster

Hermes kräver minst **64K** `model.context_length` och vägrar verktygsanrop om Ollamas runtime-kontext (`ollama_num_ctx`) är under 64K — 32K är alltså inte körbart. Därför står `config.yaml` och `hermes/Modelfile` båda på **65536**. Hermes skickar dessutom `options.num_ctx` per request till Ollama, så Modelfilen är mest ett skyddsnät för andra klienter. (qwen3:8b:s nativa fönster är 40 960; sessionerna håller sig långt under.) Återskapa modellen vid behov:

```bash
ollama create qwen3:8b -f ~/Code/luna/hermes/Modelfile
```
