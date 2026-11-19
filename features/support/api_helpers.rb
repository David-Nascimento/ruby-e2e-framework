# frozen_string_literal: true

# Clientes de API e limpeza de dados do cenário
module ApiHelpers
  def api_client
    @api_client ||= ApiClient.new
  end

  def users_api
    @users_api ||= UsersApi.new(api_client)
  end

  def auth_api
    @auth_api ||= AuthApi.new(api_client)
  end

  def products_api
    @products_api ||= ProductsApi.new(api_client)
  end

  def cleanup
    @cleanup ||= Cleanup.new
  end

  # Cria o usuário via API (precondição: tem que dar 201) e agenda a exclusão no fim do cenário
  def registrar_usuario(usuario)
    response = users_api.create(usuario)
    expect(response.status).to eq(201), "Falha ao preparar usuário: #{response.status} #{response.body}"
    agendar_exclusao_de_usuario(usuario, response)
  end

  def agendar_exclusao_de_usuario(usuario, response)
    return unless response.status == 201

    id = response.body['_id']
    cleanup.register("excluir usuário #{usuario[:email]}") { users_api.delete(id) }
  end

  def agendar_exclusao_de_produto(response, token)
    return unless response.status == 201

    id = response.body['_id']
    cleanup.register("excluir produto #{id}") { products_api.delete(id, token: token) }
  end
end

World(ApiHelpers)
