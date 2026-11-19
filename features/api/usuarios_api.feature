# language: pt
@api @regression
Funcionalidade: API de usuários e produtos (ServeRest)
  Como QA
  Quero validar os contratos da API
  Para preparar dados e garantir as regras de negócio

  @smoke @REQ-API-USER-001
  Cenário: Cadastrar usuário administrador com sucesso
    Quando cadastro um novo usuário administrador via API
    Então a API deve responder com status 201
    E a mensagem da API deve ser "Cadastro realizado com sucesso"

  @REQ-API-USER-002
  Cenário: Não permitir e-mail duplicado
    Dado que existe um usuário cadastrado via API
    Quando tento cadastrar outro usuário com o mesmo e-mail
    Então a API deve responder com status 400
    E a mensagem da API deve ser "Este email já está sendo usado"

  @smoke @REQ-API-AUTH-001
  Cenário: Login via API retorna token
    Dado que existe um usuário cadastrado via API
    Quando faço login via API com as credenciais dele
    Então a API deve responder com status 200
    E a resposta deve conter um token de autorização

  @REQ-API-AUTH-002
  Cenário: Login via API com senha incorreta
    Dado que existe um usuário cadastrado via API
    Quando faço login via API com uma senha incorreta
    Então a API deve responder com status 401
    E a mensagem da API deve ser "Email e/ou senha inválidos"

  @REQ-API-PROD-001
  Cenário: Administrador cadastra produto
    Dado que existe um usuário cadastrado via API
    E que estou autenticado na API
    Quando cadastro um novo produto via API
    Então a API deve responder com status 201
    E a mensagem da API deve ser "Cadastro realizado com sucesso"

  @REQ-API-PROD-002
  Cenário: Usuário comum não pode cadastrar produto
    Dado que existe um usuário comum cadastrado via API
    E que estou autenticado na API
    Quando cadastro um novo produto via API
    Então a API deve responder com status 403
    E a mensagem da API deve ser "Rota exclusiva para administradores"
