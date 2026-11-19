# frozen_string_literal: true

Dado("que estou na página de login do ServeRest") do
  serverest_login_page.abrir
end

Quando("faço login no ServeRest com o usuário criado") do
  serverest_login_page.entrar(email: @usuario[:email], password: @usuario[:password])
end

Quando("faço login no ServeRest com uma senha incorreta") do
  serverest_login_page.entrar(email: @usuario[:email], password: "#{@usuario[:password]}_errada")
end

Então("devo estar na home do administrador") do
  expect(serverest_home_page.carregada?).to be_truthy
end

Então("devo ver o alerta {string}") do |mensagem|
  expect(serverest_login_page.mensagem_de_erro).to include(mensagem)
end
