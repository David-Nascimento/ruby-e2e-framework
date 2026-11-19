# frozen_string_literal: true

# Endpoints de /usuarios
class UsersApi
  def initialize(client)
    @client = client
  end

  def create(user)
    @client.request(:post, "/usuarios", body: user)
  end

  def find(id)
    @client.request(:get, "/usuarios/#{id}")
  end

  def list(params = {})
    @client.request(:get, "/usuarios", params: params)
  end

  def delete(id)
    @client.request(:delete, "/usuarios/#{id}")
  end
end
