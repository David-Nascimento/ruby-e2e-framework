# language: pt
@hybrid @regression
Funcionalidade: Login no ServeRest (dados via API, validação pela interface)
  Os dados são preparados pela API (rápido e estável) e o teste valida só o que importa na UI.

  @smoke
  Cenário: Administrador criado via API consegue entrar pela interface
    Dado que existe um usuário cadastrado via API
    E que estou na página de login do ServeRest
    Quando faço login no ServeRest com o usuário criado
    Então devo estar na home do administrador

  Cenário: Senha incorreta é recusada na interface
    Dado que existe um usuário cadastrado via API
    E que estou na página de login do ServeRest
    Quando faço login no ServeRest com uma senha incorreta
    Então devo ver o alerta "Email e/ou senha inválidos"
