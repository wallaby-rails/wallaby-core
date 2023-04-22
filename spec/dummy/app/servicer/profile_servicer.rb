# frozen_string_literal: true

class ProfileServicer < Wallaby::ModelServicer
  def permit(params, _action)
    params.fetch(:profile, params).permit(model_decorator.form_field_names)
  end

  def new(_params)
    Profile.new
  end

  def find(_id, _params)
    Profile.find
  end

  def create(resource, params)
    resource.assign params
    resource.id = Random.rand(1000)
    Profile.save resource
  end

  def update(resource, params)
    resource.assign params
    Profile.save resource
  end

  def destroy(resource, _params)
    Profile.destroy resource
  end
end
