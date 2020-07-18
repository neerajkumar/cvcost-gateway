require 'yaml'
require 'her'
require 'lib/token_authentication'
require 'lib/cvcost_custom_parser'

class Base

  include Her::Model
  @@apis = {}

  def self.register_services
    config_file = File.dirname(__FILE__) + "/../../config/cvcost_services.yml"
    cvcost_services_config = YAML.load_file(config_file)[ENV['RACK_ENV']]
    cvcost_services_config.deep_symbolize_keys!

    cvcost_services_config.each do |service_name, service|
      api = Her::API.new

      api.setup url: service[:endpoint] do |c|
        c.use TokenAuthentication
        c.use Faraday::Request::UrlEncoded
        c.use CvcostCustomParser
        #c.use Her::Middleware::DefaultParseJSON
        c.use Faraday::Response::Logger, Api.logger
        c.use FaradayMiddleware::FollowRedirects
        c.use Faraday::Response::RaiseError
        c.use Faraday::Adapter::NetHttp
      end

      @@apis[service_name] = api
    end
  end

  def self.establish_connection(name)
    use_api @@apis[name]
  end
end
