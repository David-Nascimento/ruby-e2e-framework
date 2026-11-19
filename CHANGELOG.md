# Changelog

Todas as mudanças relevantes deste projeto são registradas aqui.
Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/) e versionamento [SemVer](https://semver.org/lang/pt-BR/).

## [1.0.0] - 2026-11-19

Primeira versão estável.

### Adicionado
- **Base E2E**: Ruby + Cucumber (Gherkin em português) + Selenium WebDriver + RSpec expectations, com Page Object Pattern, `BasePage` com esperas explícitas (sem `sleep`) e screenshot automático em falha.
- **Configuração** por variáveis de ambiente (`.env`), suporte a Chrome e Firefox, modo headless e execução local ou em Selenium Grid (`REMOTE_URL`).
- **Camada de API** (Faraday): clients de usuários, login e produtos, mais cenários `@api` sem navegador contra o ServeRest.
- **Cenários híbridos** `@hybrid`: dados preparados via API e validação na interface.
- **Factories** (`UserFactory`, `ProductFactory`) com dados únicos, seguras para execução paralela.
- **Limpeza de dados**: cada dado criado registra como ser desfeito, e o hook `After` executa em ordem inversa.
- **Acessibilidade** `@a11y` com axe-core (WCAG 2.1 A/AA), relatório anexado ao cenário e baseline de problemas conhecidos (`config/a11y_baseline.yml`).
- **Perfis de execução** (`default`, `smoke`, `api`, `ui`, `a11y`, `regression`, `ci`), tarefas Rake e execução paralela.
- **Rastreabilidade**: tags `@REQ-<ÁREA>-<NNN>` ligando cada cenário a um requisito.
- **Qualidade**: RuboCop, `.gitattributes` (LF), `CONTRIBUTING.md` e template de Pull Request.
- **Docker**: `docker-compose.yml` com Selenium Grid (Chromium) e os testes, com visualização ao vivo via noVNC.
- **Relatórios**: HTML do Cucumber e Allure.
- **CI** (GitHub Actions): lint, API, e2e em matriz chrome/firefox e publicação do Allure no GitHub Pages. Pausado por ora (somente disparo manual).

### Conhecido
- `image-alt` na tela de login do ServeRest está no baseline de acessibilidade (defeito do app de terceiros).
