class OrderItemsController < ApplicationController
  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def order_items_params
    params.require(:order_item).permit(:quantity, :product_id, :order_id)
  end
end
