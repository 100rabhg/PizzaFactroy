class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    order = Order.new(order_params)

    side_ids = params[:order][:side_ids]
    order.sides << Side.where(id: side_ids) if side_ids.present?

    if order.save
      render json: order, status: :created
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end

  def update_status
    order = Order.find_by(id: params[:id])

    if order&.update(status: params[:status])
      render json: order, status: :ok
    else
      render json: { error: order&.errors || "Order not found" }, status: :unprocessable_entity
    end
  end

  def show
    order = Order.find_by(id: params[:id])

    if order
      render json: format_order(order), status: :ok
    else
      render json: { error: "Order not found" }, status: :not_found
    end
  end

  private

    def order_params
    params.require(:order).permit(
      :customer_name,
      :status,
      pizzas_attributes: [:name, :category, :size, :price, :crust_id, topping_ids: []],
      side_ids: []
    )
  end

end
