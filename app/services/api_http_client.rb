require 'faraday'
require 'faulty'
require 'uri'

class ApiHttpClient

  def self.fetch(url, path, params = {})
    uri = URI.parse(url.to_s)
    ApiCircuitBreaker.circuit(uri.host).run do
      connection(url).get(path, params)
    end
  rescue Faulty::CircuitError
    ApiCircuitBreaker.fallback
  end

  def self.connection(api_url)
    @connection ||= Faraday.new(api_url) do |config|
      config.request :url_encoded
      config.response :raise_error
      config.adapter Faraday.default_adapter
    end
  end
end