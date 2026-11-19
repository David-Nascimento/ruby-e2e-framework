# frozen_string_literal: true

require 'securerandom'

# Gera usuários válidos para a API. O sufixo aleatório evita colisão entre execuções e processos paralelos.
module UserFactory
  module_function

  def build(admin: true, **overrides)
    {
      nome: Faker::Name.name,
      email: "qa.#{SecureRandom.hex(6)}@qa.com.br",
      password: Faker::Internet.password(min_length: 8, max_length: 12),
      administrador: admin.to_s
    }.merge(overrides)
  end
end
