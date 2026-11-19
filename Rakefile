# frozen_string_literal: true

desc "Roda os testes @smoke"
task :smoke do
  sh "bundle exec cucumber -p smoke"
end

desc "Roda a regressão completa"
task :regression do
  sh "bundle exec cucumber -p regression"
end

desc "Roda o RuboCop"
task :lint do
  sh "bundle exec rubocop"
end

desc "Roda em paralelo (N processos, padrão 4). Uso: rake \"parallel[4]\""
task :parallel, [:n] do |_t, args|
  FileUtils.mkdir_p("reports")
  sh "bundle exec parallel_cucumber features -n #{args[:n] || 4} -o \"-p default\""
end

task default: :smoke
