# frozen_string_literal: true

class InventoryPage < BasePage
  TITLE      = { css: "[data-test='title']" }.freeze
  CART_BADGE = { css: "[data-test='shopping-cart-badge']" }.freeze
  CART_LINK  = { css: "[data-test='shopping-cart-link']" }.freeze

  def carregada?
    text_of(TITLE) == 'Products'
  end

  def adicionar_produto(nome)
    click(botao_adicionar(nome))
  end

  def remover_produto(nome)
    click(botao_remover(nome))
  end

  def quantidade_no_carrinho
    present?(CART_BADGE) ? text_of(CART_BADGE).to_i : 0
  end

  def abrir_carrinho
    click(CART_LINK)
  end

  private

  def slug(nome)
    nome.downcase.gsub(/\s+/, '-')
  end

  def botao_adicionar(nome)
    { css: "[data-test='add-to-cart-#{slug(nome)}']" }
  end

  def botao_remover(nome)
    { css: "[data-test='remove-#{slug(nome)}']" }
  end
end
