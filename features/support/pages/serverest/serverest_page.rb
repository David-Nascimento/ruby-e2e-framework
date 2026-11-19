# frozen_string_literal: true

# Base das páginas do front do ServeRest (URL diferente do SauceDemo)
class ServerestPage < BasePage
  def base_url
    Config.serverest_ui_url
  end
end
