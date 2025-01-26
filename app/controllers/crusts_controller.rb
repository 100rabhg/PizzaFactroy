class CrustsController < ApplicationController
  include CrudController

  before_action :lock_object, only: :update

  def index
    crusts = Crust.all
    render json: crusts, each_serializer: CrustSerializer, include_stock_quantity: true
  end

  private

  def model
    Crust
  end

  def response_object(crust)
    render json: crust, serializer: CrustSerializer, include_stock_quantity: true
  end

  def permitted_params
    params.require(:crust).permit(:name, :stock_quantity)
  end
end
