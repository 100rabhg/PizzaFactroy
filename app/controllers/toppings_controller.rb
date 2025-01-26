class ToppingsController < ApplicationController
  include CrudController

  before_action :lock_object, only: :update

  def index
    toppings = Topping.all
    render json: toppings, each_serializer: ToppingSerializer, include_stock_quantity: true
  end

  private

  def model
    Topping
  end

  def response_object(topping)
    render json: topping, serializer: ToppingSerializer, include_stock_quantity: true
  end

  def permitted_params
    params.require(:topping).permit(:name, :category, :price, :stock_quantity)
  end
end
