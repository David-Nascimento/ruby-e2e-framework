# frozen_string_literal: true

# Configuração central. Tudo vem de variáveis de ambiente (.env), com defaults seguros.
module Config
  module_function

  def base_url
    ENV.fetch("BASE_URL", "https://www.saucedemo.com")
  end

  def browser
    ENV.fetch("BROWSER", "chrome").to_sym
  end

  def headless?
    ENV.fetch("HEADLESS", "true") == "true"
  end

  def timeout
    ENV.fetch("TIMEOUT", "10").to_i
  end

  def screenshots_dir
    ENV.fetch("SCREENSHOTS_DIR", "reports/screenshots")
  end

  def user(name = :standard)
    {
      standard: { username: ENV.fetch("STANDARD_USER", "standard_user"),
                  password: ENV.fetch("PASSWORD", "secret_sauce") },
      locked: { username: ENV.fetch("LOCKED_USER", "locked_out_user"),
                password: ENV.fetch("PASSWORD", "secret_sauce") }
    }.fetch(name)
  end
end
