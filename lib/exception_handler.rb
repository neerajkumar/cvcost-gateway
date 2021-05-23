module ExceptionHandler
  extend ActiveSupport::Concern

  def catch_error(&block)
    begin
      yield
    rescue CanCan::AccessDenied => e
      error = { response: { status: 401, body: 'Unauthorized access.' } }
      Api.log(error[:response][:body])
      Api.log(e.backtrace)
      return_errors(error[:response])
    rescue => e
      result = e.respond_to?(:handle) ? e.handle : e.message
      Api.log(e.message)
      Api.log(e.response[:body])
      Api.log(e.backtrace)
      return_errors(e.response)
    end
  end

  private

  def log_error(e)
    Api.log(e.message)
    Api.log(e.response[:body])
    Api.log(e.backtrace)
  end

  def return_errors(error)
    response.status = error[:status]
    request.halt [status, {'Content-Type'=>'application/json'}, [{success: false, error: error[:body]}.to_json]]
  end
end
