Aufgabe 1
git commit --allow-empty -m "fix: test patch tagging"
git commit --allow-empty -m "feat: test minor tagging"
git commit --allow-empty -m "feat!: test major tagging"

Aufgabe 2
git add .
git commit -m "fix: configure automatic version tagging"
git -c push.followTags=false push origin main
-> tags in GitHub


GitHub Workflows 2:

## Tests und Pipeline prüfen
Die folgenden Befehle im Ordner `semantic` ausführen.
Zuvor die Abhängigkeiten mit `npm ci` und die Playwright-Browser
mit `npx playwright install` installieren.

```bash
npm run test:unit
npm run test:e2e
npm run lint
npm run build
```

### Pipeline ohne Dateiänderung auslösen

```bash
git commit --allow-empty -m "ci: trigger pipeline"
git push
```
