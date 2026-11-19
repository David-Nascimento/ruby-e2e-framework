# frozen_string_literal: true

module AccessibilityHelpers
  def accessibility
    @accessibility ||= AxeRunner.new(driver)
  end
end

World(AccessibilityHelpers)
