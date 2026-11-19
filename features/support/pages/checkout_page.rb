# frozen_string_literal: true

class CheckoutPage < BasePage
  FIRST_NAME = { css: "[data-test='firstName']" }.freeze
  LAST_NAME  = { css: "[data-test='lastName']" }.freeze
  POSTAL     = { css: "[data-test='postalCode']" }.freeze
  CONTINUE   = { css: "[data-test='continue']" }.freeze
  FINISH     = { css: "[data-test='finish']" }.freeze
  COMPLETE   = { css: "[data-test='complete-header']" }.freeze

  def preencher_dados(nome:, sobrenome:, cep:)
    type(FIRST_NAME, nome)
    type(LAST_NAME, sobrenome)
    type(POSTAL, cep)
    click(CONTINUE)
  end

  def finalizar
    click(FINISH)
  end

  def mensagem_de_conclusao
    text_of(COMPLETE)
  end
end
