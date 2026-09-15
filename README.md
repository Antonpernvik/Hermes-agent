# Luna

Hermes + Ollama (`qwen3:8b`) + Obsidian-vault. Allt körs lokalt — inga moln-API-nycklar.

- `vault/` — Obsidian-vault (öppna den här mappen i Obsidian)
- `hermes/` — Lunas Hermes-hem: `SOUL.md`, `config.yaml`, wrappern `luna`
- `hermes/hermes-agent/` — Nous Research Hermes Agent (installeras lokalt, committas inte)

## Starta

```bash
source ~/.zshrc   # första gången, så att `hermes` och `luna` finns på PATH
luna              # interaktiv CLI mot vaulten
luna chat -q "Anteckna att jag ska ringa Jakob på måndag"
```

`luna` sätter `HERMES_HOME=~/Code/luna/hermes`, startar i `vault/` och kopplar bort molnnycklar från skalet.

Modell: lokal Ollama `qwen3:8b` på `http://localhost:11434/v1`.

Ollamas OpenAI-endpoint kan inte sätta kontext per request. `hermes/Modelfile` bakar in `num_ctx 32768` i `qwen3:8b` (behövs så att systemprompt + filverktyg inte kapas). Återskapa vid behov:

```bash
ollama create qwen3:8b -f ~/Code/luna/hermes/Modelfile
```
