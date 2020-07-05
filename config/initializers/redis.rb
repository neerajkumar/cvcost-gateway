require 'yaml'

file_name = File.dirname(__FILE__) + '/../redis.yml'

if File.exist?(file_name)
  config_file = File.open(file_name)
  redis_static_config = YAML.load_file(config_file)['static'].symbolize_keys
  options = { host: redis_static_config[:host], port: redis_static_config[:port] }
  $redis = Redis.new(options)
end
