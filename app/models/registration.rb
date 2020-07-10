class Registration < Base
  establish_connection :users

  def update(params)
    byebug
  end
end
