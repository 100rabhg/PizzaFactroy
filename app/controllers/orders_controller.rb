class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def create
    order = Order.new(order_params)

    if params[:order][:side_ids].present?
      order.sides = Side.where(id: params[:order][:side_ids].uniq) # Avoid duplicates
    end

    if order.save
      render json: order, status: :created
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end

  def update_status
    order = Order.find(params[:id])

    if params[:status] == 'approved'
      begin
        order.update!(status: 'approved')
        render json: { message: 'Order approved and stock deducted', order: order }, status: :ok
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    else
      if order.update(status: params[:status])
        render json: { message: 'Order status updated', order: order }, status: :ok
      else
        render json: order.errors, status: :unprocessable_entity
      end
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
