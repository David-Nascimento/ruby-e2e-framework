# language: pt
@regression
Funcionalidade: Login
  Como cliente da loja
  Quero me autenticar
  Para acessar o catálogo de produtos

  Contexto:
    Dado que estou na página de login

  @smoke @critical @REQ-AUTH-001
  Cenário: Login com credenciais válidas
    Quando faço login com o usuário "padrão"
    Então devo ver a lista de produtos

  @REQ-AUTH-002
  Cenário: Login com usuário bloqueado
    Quando faço login com o usuário "bloqueado"
    Então devo ver a mensagem de erro "Epic sadface: Sorry, this user has been locked out."

  @REQ-AUTH-003
  Esquema do Cenário: Login com credenciais inválidas
    Quando faço login com usuário "<usuario>" e senha "<senha>"
    Então devo ver a mensagem de erro "<mensagem>"

    Exemplos:
      | usuario       | senha        | mensagem                                                                  |
      | standard_user | senha_errada | Epic sadface: Username and password do not match any user in this service |
      |               | secret_sauce | Epic sadface: Username is required                                        |
      | standard_user |              | Epic sadface: Password is required                                        |
