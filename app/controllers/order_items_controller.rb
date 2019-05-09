class OrderItemsController < ApplicationController
  skip_before_action :require_login

  def create
    @order = current_order
    if @order == nil
      @order = Order.new(status: "pending")
      successful = @order.save
    end
    @order_item = OrderItem.new(product_id: params["product_id"])
    @order_item.order_id = @order.id

    product = Product.find_by(id: params[:product_id])
    unless product
      head :not_found
      return
    end
    @order_quantity = 1
    @order_item.quantity = @order_quantity
    if @order_quantity <= product.stock
      session[:order_id] = @order.id
      @order_item.save
      flash[:status] = :success
      flash[:message] = "Added to cart!"
      redirect_to root_path
    else
      flash.now[:status] = :error
      flash.now[:message] = "Unable to add to cart, not enough items in stock."
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    params[:order_items].each do |id, qty|
      @order_item = OrderItem.find_by(id: id)
      stock = @order_item.product.stock
      if qty.to_i <= stock
        successful = @order_item.update(quantity: qty)
        if successful
          flash[:status] = :success
          flash[:message] = "Successfully updated order"
        else
          flash.now[:status] = :error
          flash.now[:message] = "Unable to update order: #{@order_item.errors.messages}"
        end
      else
        flash[:status] = :error
        flash[:message] = "Unable to add #{@order_item.product.name} to cart, not enough items in stock."
      end
    end
    redirect_to order_path(@order_item.order)
  end

  def destroy
    product = params[:id]
    @order_item = OrderItem.find_by(id: params[:id])
    unless @order_item
      head :not_found
      return
    end
    @order_item.destroy
    flash[:status] = :success
    flash[:message] = "Successfully deleted item"
    redirect_to order_path(session[:order_id])
  end

  private

  def order_items_params
    params.require(:order_item).permit(:quantity, :product_id)
  end
end
