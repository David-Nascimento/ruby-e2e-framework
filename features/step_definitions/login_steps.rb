# frozen_string_literal: true

USUARIOS = { 'padrão' => :standard, 'bloqueado' => :locked }.freeze

Dado('que estou na página de login') do
  login_page.abrir
end

Dado('que estou logado como usuário {string}') do |tipo|
  login_page.abrir
  login_page.entrar(**Config.user(USUARIOS.fetch(tipo)))
  expect(inventory_page.carregada?).to be true
end

Quando('faço login com o usuário {string}') do |tipo|
  login_page.entrar(**Config.user(USUARIOS.fetch(tipo)))
end

Quando('faço login com usuário {string} e senha {string}') do |usuario, senha|
  login_page.entrar(username: usuario, password: senha)
end

Então('devo ver a lista de produtos') do
  expect(inventory_page.carregada?).to be true
  expect(inventory_page.current_path).to eq('/inventory.html')
end

Então('devo ver a mensagem de erro {string}') do |mensagem|
  expect(login_page.mensagem_de_erro).to eq(mensagem)
end
