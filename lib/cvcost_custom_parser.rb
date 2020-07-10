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
    env[:body] = { data: json || {} }
  rescue ::MultiJson::ParseError
    raise GatewayException.new(env[:body], env[:status])
  end
end
