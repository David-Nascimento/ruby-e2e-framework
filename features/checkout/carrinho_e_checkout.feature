# language: pt
@regression
Funcionalidade: Carrinho e checkout
  Como cliente autenticado
  Quero comprar produtos
  Para concluir meu pedido

  Contexto:
    Dado que estou logado como usuário "padrão"

  @smoke
  Cenário: Adicionar produto ao carrinho
    Quando adiciono o produto "Sauce Labs Backpack" ao carrinho
    Então o carrinho deve indicar 1 item
    E ao abrir o carrinho devo ver o produto "Sauce Labs Backpack"

  Cenário: Remover produto do carrinho
    Dado que adicionei o produto "Sauce Labs Bike Light" ao carrinho
    Quando removo o produto "Sauce Labs Bike Light" do carrinho
    Então o carrinho deve indicar 0 itens

  @critical
  Cenário: Finalizar compra com sucesso
    Dado que adicionei o produto "Sauce Labs Onesie" ao carrinho
    Quando abro o carrinho e inicio o checkout
    E preencho os dados de entrega com dados aleatórios
    E finalizo a compra
    Então devo ver a confirmação "Thank you for your order!"
