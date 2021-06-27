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

    r.patch do
      authenticate_user! do
        authorize! :update, @model, id
        resp = @model.save_existing(id, @data)
        response.status = 200
        return { success: true, id: resp.job_post['id'], message: resp.message }
      end
    end

    r.delete do
      authenticate_user! do
        authorize! :destroy, @model, id
        resp = @model.destroy_existing(id)
        response.status = 200
        return { success: true, message: resp.message }
      end
    end
  end

  r.post do
    authenticate_user! do
      authorize! :create, @model
      resp = @model.create(@data)
      return { success: true, id: resp.id, message: resp.message }
    end
  end

  r.get do
    authenticate_user! do
      authorize! :read, @model
      data = @model.where(query).all.fetch

      return data.map { |model| JSON.parse(model.to_json)['_her_attributes'].merge!(success: true) }
    end
  end
end
