# frozen_string_literal: true

# Cria o WebDriver conforme BROWSER/HEADLESS. Com REMOTE_URL usa o Selenium Grid;
# sem ele, usa o navegador local (o Selenium Manager baixa o driver sozinho).
module DriverFactory
  module_function

  def build
    options = browser_options
    if Config.remote_url
      Selenium::WebDriver.for(:remote, url: Config.remote_url, options: options)
    else
      Selenium::WebDriver.for(Config.browser, options: options)
    end
  end

  def browser_options
    case Config.browser
    when :chrome then chrome_options
    when :firefox then firefox_options
    else raise ArgumentError, "Browser não suportado: #{Config.browser}"
    end
  end

  def chrome_options
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless=new') if Config.headless?
    options.add_preference('credentials_enable_service', false)
    options.add_preference('profile.password_manager_enabled', false)
    options.add_preference('profile.password_manager_leak_detection', false)
    %w[--window-size=1920,1080 --no-sandbox --disable-dev-shm-usage --disable-gpu].each do |arg|
      options.add_argument(arg)
    end
    options
  end

  def firefox_options
    options = Selenium::WebDriver::Firefox::Options.new
    options.add_argument('-headless') if Config.headless?
    options
  end
end
