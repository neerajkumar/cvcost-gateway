require 'bundler'
require 'open-uri'

env = ENV['RACK_ENV'] || 'development'
Bundler.require('default', env)

$:.unshift '.'

env_type = ENV['RACK_ENV_TYPE'] || 'local'
Dotenv.load(File.dirname(__FILE__) + "/.env.#{env_type}")
module Api
  class << self
    def root
      File.dirname(__FILE__)
    end

    def logger
      @logger ||= Logger.new($stdout)
    end

    def log(*data)
      logger.info(*data)
    end
  end
end

def require_files(files)
  files.each { |f| require f }
end

models = Dir['./app/models/**/*.rb']
handlers = ['./app/routes.rb'] + Dir['./app/handlers/**/*.rb']

require_files(models)
require_files(handlers)

require './app/routes'
