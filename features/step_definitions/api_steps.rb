# frozen_string_literal: true

Dado('que existe um usuário cadastrado via API') do
  @usuario = UserFactory.build(admin: true)
  registrar_usuario(@usuario)
end

Dado('que existe um usuário comum cadastrado via API') do
  @usuario = UserFactory.build(admin: false)
  registrar_usuario(@usuario)
end

Dado('que estou autenticado na API') do
  @token = auth_api.token(email: @usuario[:email], password: @usuario[:password])
  expect(@token).to start_with('Bearer ')
end

Quando('cadastro um novo usuário administrador via API') do
  @usuario = UserFactory.build(admin: true)
  @response = users_api.create(@usuario)
  agendar_exclusao_de_usuario(@usuario, @response)
end

Quando('tento cadastrar outro usuário com o mesmo e-mail') do
  @response = users_api.create(UserFactory.build(email: @usuario[:email]))
end

Quando('faço login via API com as credenciais dele') do
  @response = auth_api.login(email: @usuario[:email], password: @usuario[:password])
end

Quando('faço login via API com uma senha incorreta') do
  @response = auth_api.login(email: @usuario[:email], password: "#{@usuario[:password]}_errada")
end

Quando('cadastro um novo produto via API') do
  produto = ProductFactory.build
  @response = products_api.create(produto, token: @token)
  agendar_exclusao_de_produto(@response, @token)
end

Então('a API deve responder com status {int}') do |status|
  expect(@response.status).to eq(status), "Resposta inesperada: #{@response.status} #{@response.body}"
end

Então('a mensagem da API deve ser {string}') do |mensagem|
  expect(@response.body['message']).to eq(mensagem)
end

Então('a resposta deve conter um token de autorização') do
  expect(@response.body['authorization']).to start_with('Bearer ')
end
