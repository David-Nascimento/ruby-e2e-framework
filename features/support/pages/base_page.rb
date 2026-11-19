# frozen_string_literal: true

# Classe base dos Page Objects: esperas explícitas, sem sleep.
class BasePage
  def initialize(driver)
    @driver = driver
    @wait = Selenium::WebDriver::Wait.new(timeout: Config.timeout, interval: 0.2)
  end

  def base_url
    Config.base_url
  end

  def visit(path = "")
    @driver.navigate.to("#{base_url}#{path}")
  end

  def current_path
    URI.parse(@driver.current_url).path
  end

  protected

  # Espera o elemento existir e estar visível
  def find(locator)
    @wait.until do
      element = @driver.find_element(locator)
      element if element.displayed?
    end
  end

  def find_all(locator)
    @driver.find_elements(locator)
  end

  def click(locator)
    @wait.until do
      element = @driver.find_element(locator)
      if element.displayed? && element.enabled?
        element.click
        true
      end
    end
  end

  def type(locator, text)
    element = find(locator)
    element.clear
    element.send_keys(text)
  end

  def text_of(locator)
    find(locator).text
  end

  def present?(locator)
    @driver.find_elements(locator).any?(&:displayed?)
  end
end
