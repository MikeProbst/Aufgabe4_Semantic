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


# sematic

This template should help get you started developing with Vue 3 in Vite.

## Recommended IDE Setup

[VS Code](https://code.visualstudio.com/) + [Vue (Official)](https://marketplace.visualstudio.com/items?itemName=Vue.volar) (and disable Vetur).

## Recommended Browser Setup

- Chromium-based browsers (Chrome, Edge, Brave, etc.):
  - [Vue.js devtools](https://chromewebstore.google.com/detail/vuejs-devtools/nhdogjmejiglipccpnnnanhbledajbpd)
  - [Turn on Custom Object Formatter in Chrome DevTools](http://bit.ly/object-formatters)
- Firefox:
  - [Vue.js devtools](https://addons.mozilla.org/en-US/firefox/addon/vue-js-devtools/)
  - [Turn on Custom Object Formatter in Firefox DevTools](https://fxdx.dev/firefox-devtools-custom-object-formatters/)

## Customize configuration

See [Vite Configuration Reference](https://vite.dev/config/).

## Project Setup

```sh
npm install
```

### Compile and Hot-Reload for Development

```sh
npm run dev
```

### Compile and Minify for Production

```sh
npm run build
```

### Run Unit Tests with [Vitest](https://vitest.dev/)

```sh
npm run test:unit
```

### Run End-to-End Tests with [Playwright](https://playwright.dev)

```sh
# Install browsers for the first run
npx playwright install

# When testing on CI, must build the project first
npm run build

# Runs the end-to-end tests
npm run test:e2e
# Runs the tests only on Chromium
npm run test:e2e -- --project=chromium
# Runs the tests of a specific file
npm run test:e2e -- tests/example.spec.ts
# Runs the tests in debug mode
npm run test:e2e -- --debug
```

### Lint with [ESLint](https://eslint.org/)

```sh
npm run lint
```


