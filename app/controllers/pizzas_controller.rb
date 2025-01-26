class PizzasController < ApplicationController
  include CrudController

  before_action :lock_object, only: :update

  def index
    pizzas = Pizza.all
    render json: pizzas, each_serializer: PizzaSerializer
  end

  private

  def model
    Pizza
  end

  def response_object(pizza)
    render json: pizza
  end

  def permitted_params
    params.require(:pizza).permit(:name, :category, :size, :price)
  end
end
