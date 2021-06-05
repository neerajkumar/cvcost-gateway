# -*- coding: utf-8 -*-
require_relative '../lib/authentication'
require_relative '../lib/exception_handler'

class Api::Routes < Roda
  plugin :all_verbs
  plugin :json, classes: [ Hash, Array ]
  plugin :json_parser
  plugin :multi_route
  plugin :sinatra_helpers
  plugin :not_found do
    "What?"
  end

  include CanCan::ControllerAdditions
  include Authentication
  include ExceptionHandler

  DEFAULT_STATUS = { 'GET' => 200, 'PUT' => 204, 'POST' => 201, 'DELETE' => 204, 'PATCH' => 204  }

  route do |r|
    catch_error do
      before_tasks
      r.root { ' <center> <h3> CVCOST Inc. </h3></center>' }
      r.on('job_posts') { r.route('job_posts') }
      r.on('users') { r.route('users') }
      r.on('permissions') { r.route('permissions') }
      r.on('passwords') { r.route('passwords') }
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
end
