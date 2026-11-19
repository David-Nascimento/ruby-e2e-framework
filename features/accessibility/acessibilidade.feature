# language: pt
@a11y @regression
Funcionalidade: Acessibilidade (WCAG 2.1 A/AA via axe-core)
  Como pessoa que usa tecnologia assistiva
  Quero que as telas principais não tenham barreiras graves
  Para conseguir me autenticar e comprar

  @REQ-A11Y-001
  Cenário: Tela de login do SauceDemo sem violações críticas
    Dado que estou na página de login
    Então a página não deve ter violações de acessibilidade de nível "crítico" ou pior

  @REQ-A11Y-002
  Cenário: Catálogo de produtos sem violações críticas
    Dado que estou logado como usuário "padrão"
    Então a página não deve ter violações de acessibilidade de nível "crítico" ou pior

  @REQ-A11Y-003
  Cenário: Carrinho sem violações críticas
    Dado que estou logado como usuário "padrão"
    E que adicionei o produto "Sauce Labs Backpack" ao carrinho
    Quando abro o carrinho
    Então a página não deve ter violações de acessibilidade de nível "crítico" ou pior

  @REQ-A11Y-004
  Cenário: Tela de login do ServeRest sem violações críticas
    Dado que estou na página de login do ServeRest
    Então a página não deve ter violações de acessibilidade de nível "crítico" ou pior
