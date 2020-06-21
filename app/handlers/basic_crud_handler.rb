Api::Routes.route('basic_crud') do |r|
  @data ||= r.params

  def query(id=nil)
    @default_query ||= {}
    @default_query[:id] = id if id
    @default_query
  end

  r.is(':id') do |id|
    r.get do
      @model.q(query(id))&.as_json
    end

    r.put do
      @model.q(query(id))&.update(@data)
    end

    r.delete do
      @model.q(query(id))&.delete
    end
  end

  r.post do
    @model.create(@data)
  end

  r.get do
    @model.where(query).all.fetch
  end
end
