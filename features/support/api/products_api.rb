# frozen_string_literal: true

# Endpoints de /produtos (criação e exclusão exigem token de administrador)
class ProductsApi
  def initialize(client)
    @client = client
  end

  def create(product, token:)
    @client.request(:post, "/produtos", body: product, token: token)
  end

  def list(params = {})
    @client.request(:get, "/produtos", params: params)
  end

  def delete(id, token:)
    @client.request(:delete, "/produtos/#{id}", token: token)
  end
end
