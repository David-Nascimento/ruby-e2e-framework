# frozen_string_literal: true

require 'faraday'
require 'fileutils'
require 'uri'
require 'yaml'

# Executa o axe-core (biblioteca oficial de acessibilidade da Deque) na página atual.
# O axe.min.js é baixado uma vez para tmp/ e injetado via Selenium; use AXE_JS_PATH para apontar um arquivo local.
class AxeRunner
  AXE_VERSION = ENV.fetch('AXE_VERSION', '4.14.1')
  AXE_URL = "https://cdn.jsdelivr.net/npm/axe-core@#{AXE_VERSION}/axe.min.js".freeze
  DEFAULT_TAGS = %w[wcag2a wcag2aa wcag21a wcag21aa].freeze
  IMPACTS = %w[minor moderate serious critical].freeze
  BASELINE_FILE = File.join('config', 'a11y_baseline.yml')

  # Executado no navegador: devolve só o que precisamos (regra, impacto, ajuda e elementos afetados)
  AXE_SCRIPT = <<~JS
    const tags = arguments[0];
    const done = arguments[arguments.length - 1];
    axe.run(document, { runOnly: { type: 'tag', values: tags } })
      .then((r) => done(r.violations.map((v) => ({
        id: v.id, impact: v.impact, help: v.help, helpUrl: v.helpUrl,
        targets: v.nodes.map((n) => String(n.target))
      }))))
      .catch((e) => done({ error: String(e) }));
  JS

  Violation = Struct.new(:id, :impact, :help, :help_url, :targets, keyword_init: true) do
    def severity
      IMPACTS.index(impact) || 0
    end

    def to_lines
      ["- [#{impact}] #{id}: #{help} (#{targets.size} elemento(s))",
       *targets.first(3).map { |target| "    #{target}" },
       "    #{help_url}"]
    end
  end

  Result = Struct.new(:url, :violations, :ignored, keyword_init: true) do
    def at_or_above(impact)
      minimum = IMPACTS.index(impact) || 0
      violations.select { |violation| violation.severity >= minimum }
    end

    def to_text
      [header, *violations.sort_by { |v| -v.severity }.flat_map(&:to_lines)].join("\n")
    end

    private

    def header
      "Acessibilidade (axe-core) em #{url}\n" \
        "Violações: #{violations.size} | ignoradas pelo baseline: #{ignored.size}"
    end
  end

  def self.source
    @source ||= begin
      path = ENV.fetch('AXE_JS_PATH', File.join('tmp', "axe-#{AXE_VERSION}.min.js"))
      download(path) unless File.exist?(path)
      File.read(path, encoding: 'UTF-8')
    end
  end

  def self.download(path)
    FileUtils.mkdir_p(File.dirname(path))
    response = Faraday.get(AXE_URL)
    unless response.status == 200
      raise "Não foi possível baixar o axe-core (HTTP #{response.status}). " \
            'Baixe o axe.min.js manualmente e defina AXE_JS_PATH.'
    end

    File.binwrite(path, response.body)
  end
  private_class_method :download

  def initialize(driver, tags: DEFAULT_TAGS)
    @driver = driver
    @tags = tags
  end

  def analyze
    inject_axe
    build_result(run_axe.map { |item| build_violation(item) })
  end

  private

  def inject_axe
    return if @driver.execute_script('return typeof window.axe !== "undefined"')

    @driver.execute_script(self.class.source)
  end

  def run_axe
    @driver.manage.timeouts.script_timeout = 60
    raw = @driver.execute_async_script(AXE_SCRIPT, @tags)
    raise "Falha ao executar o axe-core: #{raw['error']}" if raw.is_a?(Hash) && raw['error']

    raw
  end

  def build_violation(item)
    Violation.new(id: item['id'], impact: item['impact'], help: item['help'],
                  help_url: item['helpUrl'], targets: item['targets'])
  end

  # Separa o que o baseline já aceita (config/a11y_baseline.yml, por caminho da página) do que é novo
  def build_result(all)
    ignored_rules = baseline.fetch(URI.parse(@driver.current_url).path, [])
    ignored, violations = all.partition { |violation| ignored_rules.include?(violation.id) }
    Result.new(url: @driver.current_url, violations: violations, ignored: ignored)
  end

  def baseline
    return {} unless File.exist?(BASELINE_FILE)

    YAML.safe_load_file(BASELINE_FILE) || {}
  end
end
