---
name: luna-daily
description: Append a line to today's vault daily note.
version: 0.2.0
---

# Dagens anteckning

Vault: `/Users/antonpernvik/Code/luna/vault`
Dagens datum står i systemprompten som "Dagens datum är YYYY-MM-DD (veckodag)". Räkna aldrig ut datumet själv.

När användaren säger anteckna/kom ihåg/spara, kör i terminalen:

```
/Users/antonpernvik/Code/luna/hermes/luna-note daily "<texten>"
```

Skriptet skapar/uppdaterar `daily/<dagens datum>.md` och lägger till raden utan att skriva över något. Nämns en person eller ett projekt, kör även:

```
/Users/antonpernvik/Code/luna/hermes/luna-note people <namn> "<vad som sas>"
/Users/antonpernvik/Code/luna/hermes/luna-note projects <namn> "<vad som sas>"
```

Svara kort på svenska först när kommandot svarat `SPARAT:`. Använd aldrig `write_file`/`patch` för anteckningar.
