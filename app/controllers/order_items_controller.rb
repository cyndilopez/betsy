class OrderItemsController < ApplicationController
  skip_before_action :require_login
  skip_before_action :verify_authenticity_token

  def create
    @order = current_order
    if @order == nil
      @order = Order.new(status: "pending")
      successful = @order.save
      if !successful
        flash[:status] = :error
        flash[:message] = "Could not create order: #{@order.errors.messages}"
      end
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
      successful = @order_item.save
      if successful
        flash[:status] = :success
        flash[:message] = "Added to cart!"
        redirect_to root_path
      else
        flash[:status] = :error
        flash[:message] = "Could not add item to cart: #{@order_item.errors.messages}"
        redirect_to root_path
      end
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

    if @order_item.destroy
      flash[:status] = :success
      flash[:message] = "Successfully deleted item"

      redirect_to order_path(session[:order_id])
    else
      flash.now[:status] = :error
      flash.now[:message] = "Unable to delete"

      redirect_to root_path
    end
  end

  private

  def order_items_params
    params.require(:order_item).permit(:quantity, :product_id)
  end
end
