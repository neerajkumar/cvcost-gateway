class TokenAuthentication < Faraday::Middleware
  def call(env)
    if $redis.get(RequestStore.store[:auth_token])
      env[:request_headers]['Authorization'] = RequestStore.store[:auth_token]
    end
    env[:request_headers]['Accept'] = 'Application/JSON'
    @app.call(env)
  end
end
