# Ruby E2E Framework

![Ruby](https://img.shields.io/badge/Ruby-3.3-CC342D?logo=ruby&logoColor=white)
![Cucumber](https://img.shields.io/badge/Cucumber-9-23D96C?logo=cucumber&logoColor=white)
![Selenium](https://img.shields.io/badge/Selenium-4-43B02A?logo=selenium&logoColor=white)
![RuboCop](https://img.shields.io/badge/code%20style-RuboCop-000000)
![Docker](https://img.shields.io/badge/Docker-ready-2496ED?logo=docker&logoColor=white)

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

## Camada de API e dados de teste

Cenários `@api` rodam sem navegador (`bundle exec cucumber -p api`) contra o [ServeRest](https://serverest.dev).
Cenários `@hybrid` preparam os dados pela API e validam só o essencial na interface (`front.serverest.dev`).

- `features/support/api/`: `ApiClient` (Faraday) + um client por recurso (`UsersApi`, `AuthApi`, `ProductsApi`).
- `features/support/factories/`: geração de dados únicos (sufixo aleatório, seguro para paralelismo).
- `features/support/cleanup.rb`: cada dado criado registra como ser desfeito; o hook `After` executa em ordem inversa.
- `API_LOG=true` imprime cada requisição/resposta.

## Acessibilidade (axe-core)

Cenários `@a11y` rodam o [axe-core](https://github.com/dequelabs/axe-core) nas telas principais (WCAG 2.1 A/AA) e falham
se houver violação do nível pedido ou pior (`crítico`, `sério`, `moderado`, `leve`).

```bash
bundle exec rake a11y         # ou: bundle exec cucumber -p a11y
```

- O relatório completo de cada tela (regra, impacto, elementos, link de correção) é anexado ao cenário no HTML.
- O `axe.min.js` é baixado uma vez para `tmp/` (use `AXE_JS_PATH` para um arquivo local).
- Problemas já conhecidos e aceitos vão em `config/a11y_baseline.yml`, por página, com o motivo documentado.

## Convenções

Guia completo de contribuição, padrões e checklist de PR em [CONTRIBUTING.md](CONTRIBUTING.md).


- Tags: `@smoke`, `@regression`, `@critical`, `@api`, `@hybrid`, `@wip` (ignorada por padrão) e `@REQ-<ÁREA>-<NNN>` para rastreabilidade de requisitos.
- Steps só orquestram; seletores e interações ficam nos Page Objects.
- Sem `sleep`: apenas esperas explícitas no `BasePage`.
- Segredos e URLs por ambiente em `.env` (nunca versionado).

## Docker / Selenium Grid

```bash
docker compose up --build --abort-on-container-exit --exit-code-from tests
# ou: bundle exec rake docker
```

Sobe o Selenium (Chromium) e os testes em containers; os relatórios ficam em `./reports`.
Para assistir ao navegador ao vivo, abra http://localhost:7900 (senha `secret`).
Também dá para usar o Grid com os testes locais: suba só o grid (`docker compose up selenium`) e rode
`REMOTE_URL=http://localhost:4444/wd/hub bundle exec cucumber -p smoke`.

## Relatório Allure no GitHub Pages

O workflow `E2E` publica o relatório Allure a cada push na `main` e na execução agendada.
Configuração única: no repositório, **Settings → Pages → Source: GitHub Actions**.
O relatório fica em `https://<usuario>.github.io/<repositorio>/`.
