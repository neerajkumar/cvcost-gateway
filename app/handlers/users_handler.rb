Api::Routes.route('users') do |r|
  @data ||= r.params
  @model = Session

  def query(id=nil)
    @default_query ||= {}
    @default_query[:id] = id if id
    @default_query
  end

  r.is 'login' do
    r.post do
      resp = @model.create(@data)
      new_session = JSON.parse(resp.env.body)
      self.headers['Authorization'] = resp.env.response_headers['authorization']
      response.status = resp.status
      if new_session['success']
        $redis.set(resp.env.response_headers['authorization'].gsub('Bearer', ''), Time.now.to_s)
      end
      return new_session
    end
  end

  r.is 'logout' do
    r.delete do
      session = @model.new&.destroy
      $redis.del(RequestStore.store[:auth_token].gsub('Bearer ', ''))
      return
    end
  end
end
