# frozen_string_literal: true

# Endpoint de /login
class AuthApi
  def initialize(client)
    @client = client
  end

  def login(email:, password:)
    @client.request(:post, "/login", body: { email: email, password: password })
  end

  # Atalho: devolve o valor "Bearer <token>" ou nil se o login falhar
  def token(email:, password:)
    response = login(email: email, password: password)
    response.body["authorization"] if response.status == 200 && response.body.is_a?(Hash)
  end
end
