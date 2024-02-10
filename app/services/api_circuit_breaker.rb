require 'faulty'

class ApiCircuitBreaker

  def self.circuit(api_name)
    @circuit || begin
                  Faulty::Circuit.new(
                    api_name.to_s,
                    rate_threshold: 0.5,
                    evaluation_window: 60,
                    errors: [Faraday::Error]
                  )
                end
  end

  def self.fallback
    []
  end

end
