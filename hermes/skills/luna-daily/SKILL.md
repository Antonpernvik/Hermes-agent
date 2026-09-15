---
name: luna-daily
description: Append a line to today's vault daily note.
version: 0.1.0
---

# Dagens anteckning

Vault: `/Users/antonpernvik/Code/luna/vault`
Fil: `/Users/antonpernvik/Code/luna/vault/daily/YYYY-MM-DD.md` (dagens datum)

När användaren säger anteckna/kom ihåg/spara:
1. `read_file` på dagens fil. Om den saknas, hoppa till skriv.
2. `write_file` med befintligt innehåll plus en ny rad, eller skapa filen:
   ```
   # YYYY-MM-DD

   - <anteckningen>
   ```
3. Svara kort på svenska först efter lyckad skrivning.
