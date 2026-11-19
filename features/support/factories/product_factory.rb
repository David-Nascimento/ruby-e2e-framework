# frozen_string_literal: true

require 'securerandom'

module ProductFactory
  module_function

  def build(**overrides)
    {
      nome: "Produto #{SecureRandom.hex(4)}",
      preco: rand(10..500),
      descricao: Faker::Commerce.product_name,
      quantidade: rand(1..100)
    }.merge(overrides)
  end
end
