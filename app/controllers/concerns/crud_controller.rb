module CrudController
  extend ActiveSupport::Concern

  included do
    before_action :set_object, only: %i[show update]
  end

  def create
    @object = model.new(permitted_params)

    json_response(@object.save)
  end

  def update
    json_response(@object.update(permitted_params))
  end

  def show
    response_object(@object)
  end

  private

  def set_object
    @object = model.find(params[:id])
  end

  def json_response(is_success)
    if is_success
      response_object(@object)
    else
      render json: { errors: @object.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def model
    raise NotImplementedError, 'You must define a `model` method'
  end

  def response_object(object)
    raise NotImplementedError, 'You must define a `response_object` method'
  end

  def permitted_params
    raise NotImplementedError, 'You must define `permitted_params`'
  end
end
