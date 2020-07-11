class GatewayException < Exception
  attr_reader :message, :status

  def initialize(message, status)
    @message = message
    @status = status
  end
end

class CvcostCustomParser < Faraday::Response::Middleware
  def on_complete(env)
    json = MultiJson.load(env[:body], symbolize_keys: true)
    env[:body] = {
      data: data(json),
      errors: response_errors(json),
      metadata: metadata(json)
    }
  rescue ::MultiJson::ParseError
    raise GatewayException.new(env[:body], env[:status])
  end

  private

  def data(json)
    json || (json.is_a?(Array) ? []: {})
  end

  def response_errors(json)
    json.respond_to?(:errors) ? (json[:errors] || []) : []
  end

  def metadata(json)
    json.respond_to?(:metadata) ? (json[:metadata] || {}) : {}
  end
end
