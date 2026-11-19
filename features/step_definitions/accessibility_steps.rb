# frozen_string_literal: true

IMPACTOS = { 'crítico' => 'critical', 'sério' => 'serious', 'moderado' => 'moderate', 'leve' => 'minor' }.freeze

Quando('abro o carrinho') do
  inventory_page.abrir_carrinho
  cart_page.produtos # aguarda a página do carrinho carregar
end

Então('a página não deve ter violações de acessibilidade de nível {string} ou pior') do |nivel|
  resultado = accessibility.analyze
  attach(resultado.to_text, 'text/plain') # relatório completo anexado ao cenário
  relevantes = resultado.at_or_above(IMPACTOS.fetch(nivel))

  expect(relevantes).to be_empty, "#{relevantes.size} violação(ões) de nível #{nivel} ou pior:\n#{resultado.to_text}"
end
