# frozen_string_literal: true

class ServerestLoginPage < ServerestPage
  # Seletores com alternativa: data-testid ou o tipo do campo
  EMAIL    = { css: "[data-testid='email'], input[type='email']" }.freeze
  PASSWORD = { css: "[data-testid='senha'], input[type='password']" }.freeze
  SUBMIT   = { css: "[data-testid='entrar'], button[type='submit']" }.freeze
  ALERT    = { css: ".alert, [role='alert']" }.freeze

  def abrir
    visit("/login")
  end

  def entrar(email:, password:)
    type(EMAIL, email)
    type(PASSWORD, password)
    click(SUBMIT)
  end

  def mensagem_de_erro
    text_of(ALERT)
  end
end
