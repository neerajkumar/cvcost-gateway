Api::Routes.route('users') do |r|
  @data ||= r.params
  @model = User

  def query(id=nil)
    @default_query ||= {}
    @default_query[:id] = id if id
    @default_query
  end

  r.is 'login' do
    r.post do
      resp = Session.create(@data)
      new_session = JSON.parse(resp.env.body)
      self.headers['Authorization'] = resp.env.response_headers['authorization']
      response.status = resp.status
      if new_session['success']
        $redis.set(resp.env.response_headers['authorization'], Time.now.to_s)
      end
      return new_session
    end
  end

  r.is 'logout' do
    r.delete do
      session = Session.new&.destroy
      $redis.del(RequestStore.store[:auth_token])
      return
    end
  end

  r.is 'me' do
    r.get do
      authenticate_user! do
        user = @model.find(:me)
        return JSON.parse(user.to_json)['_her_attributes'].merge!(success: true)
      end
    end
  end
end
