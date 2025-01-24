class InventoryController < ApplicationController
  skip_before_action :verify_authenticity_token

  def update
    ActiveRecord::Base.transaction do
      update_inventory_items(params[:crusts], Crust) if params[:crusts].present?
      update_inventory_items(params[:toppings], Topping) if params[:toppings].present?
      update_inventory_items(params[:sides], Side) if params[:sides].present?
    end

    render json: { message: "Inventory updated successfully!" }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: "Item not found: #{e.message}" }, status: :unprocessable_entity
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: "Invalid stock value: #{e.message}" }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { error: "An error occurred: #{e.message}" }, status: :internal_server_error
  end

  private

  def update_inventory_items(items, model)
    items.each do |item_data|
      item = model.find(item_data[:id])

      new_stock = Integer(item_data[:stock]) rescue nil
      if new_stock.nil? || new_stock < 0
        raise ActiveRecord::RecordInvalid, "#{model.name} ID #{item.id} stock value must be a non-negative integer"
      end

      item.update!(stock: new_stock)
    end
  end
end
