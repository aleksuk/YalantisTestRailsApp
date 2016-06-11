class TaskSerializer < BaseSerializer
  attributes :id,
             :status,
             :image_id,
             :params

  def params
    JSON.parse(object.params)
  end

end
