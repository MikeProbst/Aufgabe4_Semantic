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



Aufgabe 4

## Deployment auf AWS S3

Voraussetzungen: Terraform, AWS CLI und gültige AWS-Credentials
(bei AWS Academy nach jedem Lab-Start neu aus "AWS Details" kopieren).

```bash
cd semantic

# Credentials prüfen
aws sts get-caller-identity

# S3 Bucket mit Website-Hosting erstellen (nur einmal nötig)
terraform init
terraform apply

# App bauen und hochladen
npm install
npm run build
npm run deploy-aws
```

Die Webseite ist danach erreichbar unter:
http://m324-semantic-mikeprobst.s3-website-us-east-1.amazonaws.com

Aufräumen (löscht den Bucket inkl. Inhalt):

```bash
terraform destroy
```

Hinweis: Der Bucket wird über `terraform_data` + AWS CLI erstellt statt mit
`aws_s3_bucket`, weil eine Service Control Policy im AWS Academy Lab
`s3:GetBucketObjectLockConfiguration` verbietet.

