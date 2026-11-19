# frozen_string_literal: true

# Cria o WebDriver conforme BROWSER/HEADLESS. Selenium Manager baixa o driver sozinho.
module DriverFactory
  module_function

  def build
    case Config.browser
    when :chrome then chrome
    when :firefox then firefox
    else raise ArgumentError, "Browser não suportado: #{Config.browser}"
    end
  end

  def chrome
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument("--headless=new") if Config.headless?
    options.add_preference("credentials_enable_service", false)
    options.add_preference("profile.password_manager_enabled", false)
    options.add_preference("profile.password_manager_leak_detection", false)
    %w[--window-size=1920,1080 --no-sandbox --disable-dev-shm-usage --disable-gpu].each do |arg|
      options.add_argument(arg)
    end
    Selenium::WebDriver.for(:chrome, options: options)
  end

  def firefox
    options = Selenium::WebDriver::Firefox::Options.new
    options.add_argument("-headless") if Config.headless?
    Selenium::WebDriver.for(:firefox, options: options)
  end
end
