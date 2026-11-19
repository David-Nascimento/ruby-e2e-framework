# frozen_string_literal: true

# Registro de limpeza: cada dado criado pelo teste registra como desfazê-lo.
# Ao fim do cenário as ações rodam em ordem inversa (produto antes do usuário dono dele).
class Cleanup
  def initialize
    @tasks = []
  end

  def register(description, &block)
    @tasks << [description, block]
  end

  def run!
    @tasks.reverse_each do |description, task|
      task.call
    rescue StandardError => e
      warn "[cleanup] falha ao #{description}: #{e.message}"
    end
    @tasks.clear
  end
end
