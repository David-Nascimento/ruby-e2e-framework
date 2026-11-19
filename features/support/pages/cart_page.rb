# frozen_string_literal: true

class CartPage < BasePage
  ITEM_NAME = { css: "[data-test='inventory-item-name']" }.freeze
  CHECKOUT  = { css: "[data-test='checkout']" }.freeze

  def produtos
    @wait.until { current_path == "/cart.html" }
    find_all(ITEM_NAME).map(&:text)
  end

  def iniciar_checkout
    click(CHECKOUT)
  end
end
