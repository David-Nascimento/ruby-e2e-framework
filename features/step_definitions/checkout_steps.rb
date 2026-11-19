# frozen_string_literal: true

Quando('adiciono o produto {string} ao carrinho') do |produto|
  inventory_page.adicionar_produto(produto)
end

Dado('que adicionei o produto {string} ao carrinho') do |produto|
  inventory_page.adicionar_produto(produto)
end

Quando('removo o produto {string} do carrinho') do |produto|
  inventory_page.remover_produto(produto)
end

Então('o carrinho deve indicar {int} item/itens') do |quantidade|
  expect(inventory_page.quantidade_no_carrinho).to eq(quantidade)
end

Então('ao abrir o carrinho devo ver o produto {string}') do |produto|
  inventory_page.abrir_carrinho
  expect(cart_page.produtos).to include(produto)
end

Quando('abro o carrinho e inicio o checkout') do
  inventory_page.abrir_carrinho
  cart_page.iniciar_checkout
end

Quando('preencho os dados de entrega com dados aleatórios') do
  checkout_page.preencher_dados(
    nome: Faker::Name.first_name,
    sobrenome: Faker::Name.last_name,
    cep: Faker::Number.number(digits: 8).to_s
  )
end

Quando('finalizo a compra') do
  checkout_page.finalizar
end

Então('devo ver a confirmação {string}') do |mensagem|
  expect(checkout_page.mensagem_de_conclusao).to eq(mensagem)
end
