require 'yaml'

class Session < Base
  establish_connection :users

  def self.create(params)
    conn = Faraday.new(
      url: sessions_endpoint,
      params: params,
      headers: {'Content-Type' => 'application/json'}
    )

    conn.post('sessions')
  end

  def self.sessions_endpoint
    config_file = File.dirname(__FILE__) + "/../../config/cvcost_services.yml"
    cvcost_services_config = YAML.load_file(config_file)[ENV['RACK_ENV']]
    cvcost_services_config.deep_symbolize_keys!
    cvcost_services_config[:users][:endpoint]
  end

  private_class_method :sessions_endpoint
end
