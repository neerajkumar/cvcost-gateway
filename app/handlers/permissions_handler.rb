Api::Routes.route('permissions') do |r|
  @data ||= r.params

  r.get do |accessible_entity_id, accessible_entity_class, permission|
    authenticate_user! do
      accessible_entity_class, accessible_entity_id, permission = [@data['accessible_entity_class'], @data['accessible_entity_id'], @data['permission']]
      if accessible_entity_class.blank? || permission.blank?
        response.status = 422
        return { success: false, error: { response: { status: 422, body: 'accessible_entity_class or permission can\'t be blank' } } }
      end

      accessible_entity = accessible_entity_id.present? ? accessible_entity_class.constantize.find(accessible_entity_id) : accessible_entity_class.constantize
      { success: true, can_access: can?(permission.to_sym, accessible_entity) }
    end
  end
end
