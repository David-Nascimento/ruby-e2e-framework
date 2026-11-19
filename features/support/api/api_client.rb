# frozen_string_literal: true

require "faraday"
require "json"

# Cliente HTTP genérico. Devolve sempre um Response com status, body (Hash quando JSON) e headers.
class ApiClient
  Response = Struct.new(:status, :body, :headers)

  def initialize(base_url: Config.api_url)
    @conn = Faraday.new(url: base_url) do |f|
      f.request :json
      f.response :json, content_type: /\bjson/
      f.options.timeout = Config.timeout
      f.options.open_timeout = Config.timeout
    end
  end

  def request(method, path, body: nil, params: nil, token: nil)
    headers = {}
    headers["Authorization"] = token if token
    response = @conn.run_request(method, path, body, headers) do |req|
      req.params.update(params) if params
    end
    log(method, path, response)
    Response.new(response.status, response.body, response.headers)
  end

  private

  def log(method, path, response)
    return unless ENV["API_LOG"] == "true"

    puts "[API] #{method.to_s.upcase} #{path} -> #{response.status} #{response.body.to_json[0, 300]}"
  end
end
