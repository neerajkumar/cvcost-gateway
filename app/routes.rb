# -*- coding: utf-8 -*-
class Api::Routes < Roda
  plugin :all_verbs
  plugin :json, classes: [ Hash, Array ]
  plugin :json_parser
  plugin :multi_route
  plugin :sinatra_helpers
  plugin :not_found do
    "What?"
  end

  DEFAULT_STATUS = { "GET" => 200, "PUT" => 204, "POST" => 201, "DELETE" => 204, "PATCH" => 204  }

  route do |r|
    begin
      before_tasks
      r.root { ' <center> <h3> CVCOST Inc. </h3></center>' }
      r.on('job_posts') { r.route('job_posts') }
      r.on('users') { r.route('users') }
    rescue => e
      result = e.respond_to?(:handle) ? e.handle : e.message
      Api.log(e.message)
      Api.log(e.backtrace)
      return_errors(e.response)
    ensure
      after_tasks
    end
  end

  def before_tasks
    @start_time = Time.now
    RequestStore.store[:auth_token] = request.env['HTTP_AUTHORIZATION']
    set_default_status
  end

  def after_tasks
    log_time
  end

  def log_time
    time_taken = "#{'%.3f' % ((Time.now - @start_time)*1000)} ms"
    Api.log("➜ [#{Time.now}] #{request.request_method} #{response.status} \"#{request.path}\" in #{time_taken}")
  end

  def set_default_status
    response.status = DEFAULT_STATUS[request.request_method]
  end

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


  def return_errors(error)
    response.status = error[:status]
    request.halt [status, {'Content-Type'=>'application/json'}, [{success: false, error: JSON.parse(error[:body])}.to_json]]
  end
end
