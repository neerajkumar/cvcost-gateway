Api::Routes.route('basic_crud') do |r|
  @data ||= r.params

  def query(id=nil)
    @default_query ||= {}
    @default_query[:id] = id if id
    @default_query
  end

  r.on(:id) do |id|
    r.get do
      data = @model.find(query(id))&.as_json

      return data['_her_attributes'].merge(success: true)
    end

    r.put do
      @model.q(query(id))&.update(@data)
    end

    r.delete do
      @model.q(query(id))&.delete
    end
  end

  r.post do
    authenticate_user! do
      resp = @model.create(@data)
      return { success: true, id: resp.id, message: resp.message }
    end
  end

  r.get do
    data = @model.where(query).all.fetch

    return data.map { |model| JSON.parse(model.to_json)['_her_attributes'].merge!(success: true) }
  end
end
