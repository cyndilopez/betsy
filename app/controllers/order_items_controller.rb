class OrderItemsController < ApplicationController
  def create
    @order_item = OrderItem.new(order_items_params)
    
    if @order_item.save
      flash[:status] = :success
      flash[:message] = "Added to cart!"
      redirect_to product_path(id: params[:product_id])
    else
      flash.new[:status] = :error
      flash.new[:message] = "Unable to add to cart :("
      redirect_back(fallback_location: root_path)
    end
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
