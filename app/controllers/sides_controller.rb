class SidesController < ApplicationController
  include CrudController

  before_action :lock_object, only: :update

  def index
    sides = Side.all
    render json: sides, each_serializer: SideSerializer, include_stock_quantity: true
  end

  private

  def model
    Side
  end

  def response_object(side)
    render json: side, serializer: SideSerializer, include_stock_quantity: true
  end

  def permitted_params
    params.require(:side).permit(:name, :price, :stock_quantity)
  end
end
