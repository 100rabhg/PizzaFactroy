class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :set_order, only: %i[update_status confirm]

  def create
    order = Order.new(order_params)

    if order.save
      render json: order, status: :created
    else
      render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_status
    if @order.update(status: params[:status])
      render json: @order, status: :ok
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def show
    order = Order.find_by(id: params[:id])

    if order
      render json: order, status: :ok
    else
      render json: { error: 'Order not found' }, status: :not_found
    end
  end

  def confirm
    return render json: { error: 'Order not found' }, status: :not_found if @order.nil?

    # Only allow confirmation if status is "approved"
    if @order.status != 'approved'
      return render json: { error: 'Order cannot be confirmed unless it is approved' }, status: :unprocessable_entity
    end

    insufficient_items = verify_inventory(@order)

    if insufficient_items.present?
      return render json: { error: 'Insufficient inventory', items: insufficient_items }, status: :unprocessable_entity
    end

    deduct_inventory(@order)
    @order.update(status: 'confirmed')

    render json: @order, status: :ok
  end

  private

  def verify_inventory(order)
    insufficient_items = []

    # Verify toppings inventory
    order.pizzas.each do |pizza|
      pizza.toppings.each do |topping|
        insufficient_items << { name: topping.name, type: 'Topping' } if topping.stock.nil? || topping.stock < 1
      end
    end

    # Verify sides inventory
    order.sides.each do |side|
      insufficient_items << { name: side.name, type: 'Side' } if side.stock.nil? || side.stock < 1
    end

    # Verify crust inventory
    order.pizzas.each do |pizza|
      insufficient_items << { name: pizza.crust.name, type: 'Crust' } if pizza.crust.stock.nil? || pizza.crust.stock < 1
    end

    insufficient_items.uniq
  end

  def deduct_inventory(order)
    order.pizzas.each do |pizza|
      pizza.toppings.each do |topping|
        topping.update(stock: topping.stock - 1)
      end

      pizza.crust.update(stock: pizza.crust.stock - 1)
    end

    order.sides.each do |side|
      side.update(stock: side.stock - 1)
    end
  end

  def order_params
    params.require(:order).permit(:customer_name, :status, :total_price)
  end

  def set_order
    @order = Order.find_by(id: params[:id])
  end
end
