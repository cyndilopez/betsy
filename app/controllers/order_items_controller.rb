class OrderItemsController < ApplicationController
  skip_before_action :require_login

  def create
    @order = current_order
    if @order == nil
      @order = Order.new
      @order.save
    end

    # product = Product.find(params[:product_id])
    # @order_item = OrderItem.new(order_items_params)
    #   if @order_item.save
    #     session[:order_id] = @order.id
    #     flash[:status] = :success
    #     flash[:message] = "Added to cart!"
    #     redirect_to product_path(@order_item.product_id)
    #   else
    #     flash.now[:status] = :error
    #     flash.now[:message] = "Unable to add to cart :("
    #     redirect_back(fallback_location: root_path)
    #   end
    # end

    @order_item = OrderItem.new(order_items_params)
    @order_item.order_id = @order.id
    product_quantity = @order_item.quantity
    order_item_id = Product.find_by(id: params[:product_id])

    if product_quantity < order_item_id.stock
      @order_item.reduce_product_stock(order_item_id)
      session[:order_id] = @order.id
      @order_item.save
      flash[:status] = :success
      flash[:message] = "Added to cart!"
      redirect_to product_path(@order_item.product_id)
    else
      flash.now[:status] = :error
      flash.now[:message] = "Unable to add to cart, please try again later"
      redirect_back(fallback_location: root_path)
    end
  end

  def edit
    @order_item = OrderItem.find_by(id: params[:id])

    unless @order_item
      head :not_found
      return
    end
  end

  def update
    @order_item = OrderItem.find_by(id: params[:id])

    if @order_item.update(order_items_params)
      flash[:status] = :success
      flash[:message] = "Updated #{@order_item.id}"

      @order_item.reload
    else
      flash.now[:status] = :error
      flash.now[:message] = "Unable to update"

      render :edit
    end
  end

  def destroy
    order_item_id = params[:id]
    @order_item = OrderItem.find_by(id: params[:id])

    if @order_item.destroy
      flash[:status] = :success
      flash[:messages] = "Successfully Deleted"

      render :edit
    else
      flash.now[:status] = :error
      flash.now[:messages] = "Unable to delete"

      render :edit
    end
  end

  private

  def order_items_params
    params.require(:order_item).permit(:quantity, :product_id)
  end
end
