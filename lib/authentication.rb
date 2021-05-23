module Authentication
  def authenticate_user!(&block)
    unless $redis.get(request.env['HTTP_AUTHORIZATION'])
      response.status = 401
      return { success: false, response: 'Access Denied!' }
    end
    yield
  rescue GatewayException => e
    response.status = e.status || 401
    return { success: false, response: e.message }
  end

  def current_user
    User.find(:me)
  end
end
