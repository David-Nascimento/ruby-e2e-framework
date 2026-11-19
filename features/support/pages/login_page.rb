# frozen_string_literal: true

class LoginPage < BasePage
  USERNAME = { id: 'user-name' }.freeze
  PASSWORD = { id: 'password' }.freeze
  SUBMIT   = { id: 'login-button' }.freeze
  ERROR    = { css: "[data-test='error']" }.freeze

  def abrir
    visit('/')
    find(USERNAME) # aguarda a SPA renderizar
  end

  def entrar(username:, password:)
    type(USERNAME, username)
    type(PASSWORD, password)
    click(SUBMIT)
  end

  def mensagem_de_erro
    text_of(ERROR)
  end
end
