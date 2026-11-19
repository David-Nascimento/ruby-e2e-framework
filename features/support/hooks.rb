# frozen_string_literal: true

Before do
  @driver = DriverFactory.build
  @driver.manage.timeouts.page_load = 30
end

After do |scenario|
  if scenario.failed? && @driver
    FileUtils.mkdir_p(Config.screenshots_dir)
    name = scenario.name.gsub(/[^\w-]+/, "_")[0, 80]
    path = File.join(Config.screenshots_dir, "#{name}.png")
    @driver.save_screenshot(path)
    attach(File.binread(path), "image/png")
  end
ensure
  @driver&.quit
end
