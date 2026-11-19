# frozen_string_literal: true

# Acesso preguiçoso aos Page Objects dentro dos steps: `login_page.entrar(...)`
module PageObjects
  def driver
    @driver
  end

  def login_page
    @login_page ||= LoginPage.new(driver)
  end

  def inventory_page
    @inventory_page ||= InventoryPage.new(driver)
  end

  def cart_page
    @cart_page ||= CartPage.new(driver)
  end

  def checkout_page
    @checkout_page ||= CheckoutPage.new(driver)
  end

  def serverest_login_page
    @serverest_login_page ||= ServerestLoginPage.new(driver)
  end

  def serverest_home_page
    @serverest_home_page ||= ServerestHomePage.new(driver)
  end
end

World(PageObjects)
