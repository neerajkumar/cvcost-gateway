Api::Routes.route('passwords') do |r|
  @data ||= r.params

  r.post do
    resp = Password.create(@data)
    response.status = 200
    { success: resp.success, message: resp.message }
  end
end
