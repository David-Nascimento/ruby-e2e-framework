# Guia de contribuição

Este documento define como escrever e organizar testes neste projeto, para que qualquer pessoa consiga manter a suíte.

## Preparando o ambiente

```bash
bundle install
cp .env.example .env
bundle exec cucumber --dry-run   # valida que todos os steps existem
bundle exec cucumber -p smoke    # roda o essencial
bundle exec rubocop              # lint (deve terminar com 0 offenses)
```

## Fluxo de trabalho

1. Crie uma branch a partir da `main`: `feat/<assunto>`, `fix/<assunto>` ou `chore/<assunto>`.
2. Faça commits pequenos seguindo [Conventional Commits](https://www.conventionalcommits.org/pt-br/):
   `feat:`, `fix:`, `test:`, `refactor:`, `docs:`, `chore:`.
3. Antes de abrir o PR: `bundle exec rubocop` e `bundle exec cucumber -p smoke` precisam passar.
4. Abra o PR preenchendo o template.

## Escrevendo cenários (Gherkin)

- Um cenário valida **um comportamento**. Se precisar de "E depois..." várias vezes, divida.
- Escreva no nível do **negócio**, não da tela: "Quando faço login com o usuário padrão", e não "Quando preencho o campo user-name".
- Use `Contexto` para pré-condições comuns e `Esquema do Cenário` para variações de dados.
- Idioma: português (`# language: pt`). Nomes de cenário em frases curtas e no presente.
- Dados de teste ficam nos steps ou nas factories, nunca "escondidos" no Page Object.

## Escrevendo steps

- Steps **só orquestram**: chamam Page Objects, clients de API e fazem asserções.
- Nenhum seletor (`id`, `css`, `xpath`) em step. Seletor só em Page Object.
- Asserções com `expect(...).to ...` (rspec-expectations). Para falhas legíveis, passe uma mensagem quando ajudar.
- Evite steps genéricos demais ("clico em {string}"): eles viram uma linguagem paralela difícil de manter.

## Page Objects

- Herdam de `BasePage` (ou `ServerestPage`, para o front do ServeRest).
- Seletores em constantes no topo da classe. Prefira `id` ou `data-testid`/`data-test`; evite XPath frágil.
- Use apenas os helpers do `BasePage` (`find`, `click`, `type`, `text_of`). **Proibido `sleep`**: as esperas são explícitas e já estão nos helpers.
- Métodos com nomes de ação de negócio (`entrar`, `adicionar_produto`), não de mecânica (`clicar_botao`).

## Dados de teste e limpeza

- Gere dados com as factories (`UserFactory`, `ProductFactory`); nunca use dados fixos que possam colidir.
- Prepare pré-condições pela **API**, não pela interface (mais rápido e estável).
- Todo dado criado precisa registrar sua limpeza com `cleanup.register(...)`. O hook `After` desfaz tudo ao final do cenário.
- Nunca versione segredos. Credenciais e URLs ficam no `.env` (modelo em `.env.example`).

## Tags

| Tag | Uso |
|---|---|
| `@smoke` | Caminho crítico, roda em todo PR. Mantenha a suíte pequena e rápida. |
| `@regression` | Regressão completa. |
| `@critical` | Funcionalidade cujo defeito é bloqueante. |
| `@api` | Cenário sem navegador (só API). |
| `@hybrid` | Dados via API + validação na interface. |
| `@a11y` | Acessibilidade (axe-core, WCAG 2.1 A/AA). |
| `@wip` | Em desenvolvimento. Ignorado por padrão. |
| `@REQ-<ÁREA>-<NNN>` | Rastreabilidade: liga o cenário a um requisito (veja abaixo). |

## Rastreabilidade

Cada cenário referencia o requisito que valida com uma tag `@REQ-<ÁREA>-<NNN>` (ex.: `@REQ-AUTH-001`).
Se o time usa Jira, use o ID do ticket na mesma posição (`@JIRA-123`).

Para ver a cobertura de um requisito:

```bash
bundle exec cucumber --dry-run --tags @REQ-AUTH-001
```

Cenário sem tag de requisito não passa na revisão.

## Checklist do PR

- [ ] `bundle exec rubocop` sem ofensas
- [ ] `bundle exec cucumber --dry-run` sem steps indefinidos
- [ ] Cenários novos têm tag de requisito e tags de execução (`@smoke`/`@regression`)
- [ ] Sem `sleep`, seletores em steps ou dados fixos
- [ ] Dados criados pelo teste são limpos no final
- [ ] README/CONTRIBUTING atualizados se algo de uso mudou
