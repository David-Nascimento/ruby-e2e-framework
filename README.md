# Ruby E2E Framework

Framework de automação de testes E2E com **Ruby + Cucumber (Gherkin em português) + Selenium WebDriver + RSpec expectations**, usando Page Object Pattern.
Aplicação alvo padrão: [SauceDemo](https://www.saucedemo.com).

## Stack

| Camada | Tecnologia |
|---|---|
| BDD | Cucumber 9 |
| Browser | Selenium WebDriver 4 (Selenium Manager baixa o driver) |
| Asserções | rspec-expectations |
| Dados | Faker |
| Relatórios | HTML do Cucumber + Allure |
| Qualidade | RuboCop |
| CI | GitHub Actions (matrix chrome/firefox) |

## Estrutura

```
config/cucumber.yml          perfis: default, smoke, regression, ci
features/
  login/ checkout/           cenários .feature por domínio
  step_definitions/          steps finos, sem lógica de tela
  support/
    config.rb                configuração via ENV
    driver_factory.rb        criação do browser
    env.rb hooks.rb world.rb setup, screenshot em falha, acesso aos pages
    pages/                   Page Objects (BasePage + páginas)
```

## Como rodar

```bash
bundle install
cp .env.example .env

bundle exec cucumber                 # tudo
bundle exec cucumber -p smoke        # só @smoke
bundle exec cucumber -p regression   # só @regression
HEADLESS=false bundle exec cucumber  # com o browser visível
BROWSER=firefox bundle exec cucumber
bundle exec rake "parallel[4]"       # em paralelo (aspas necessárias no PowerShell)
bundle exec rubocop                  # lint
```

Relatórios em `reports/` (HTML, screenshots de falha e `allure-results`).
Para ver o Allure: `allure serve reports/allure-results`.

## Convenções

- Tags: `@smoke`, `@regression`, `@critical`, `@wip` (ignorada por padrão).
- Steps só orquestram; seletores e interações ficam nos Page Objects.
- Sem `sleep`: apenas esperas explícitas no `BasePage`.
- Segredos e URLs por ambiente em `.env` (nunca versionado).

## Docker

```bash
docker build -t ruby-e2e .
docker run --rm -v "$PWD/reports:/app/reports" ruby-e2e
```
