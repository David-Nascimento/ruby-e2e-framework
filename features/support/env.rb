# frozen_string_literal: true

require "bundler/setup"
require "dotenv/load"
require "selenium-webdriver"
require "rspec/expectations"
require "faker"
require "fileutils"
require "allure-cucumber"

require_relative "config"
require_relative "driver_factory"

# Carrega todos os Page Objects (base primeiro)
require_relative "pages/base_page"
Dir[File.join(__dir__, "pages", "**", "*.rb")].sort.each { |file| require file }

AllureCucumber.configure do |c|
  c.results_directory = "reports/allure-results"
  # false: em execução paralela um processo não pode apagar os resultados dos outros
  c.clean_results_directory = false
end

# Disponibiliza `expect(...).to ...` do RSpec dentro dos steps
World(RSpec::Matchers)
