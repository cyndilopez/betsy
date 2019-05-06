class OrderItemsController < ApplicationController
  skip_before_action :require_login

  def create
    @order = current_order
    p @order
    if @order == nil
      @order = Order.new(status: "pending")
      @order.save
    end
    p @order
    @order_item = OrderItem.new(product_id: params["product_id"])
    @order_item.order_id = @order.id
    # product_quantity = @order_item.quantity

    product = Product.find_by(id: params[:product_id])
    p product
    @order_quantity = 1
    @order_item.quantity = @order_quantity
    if @order_quantity <= product.stock
      # @order_item.reduce_product_stock
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

  def edit
    @order_item = OrderItem.find_by(id: params[:id])

    unless @order_item
      head :not_found
      return
    end
  end

  def update
    params[:order_items].each do |id, qty|
      p id
      p qty
      # @order_item = OrderItem.find_by(id: params[:id])
      @order_item = OrderItem.find_by(id: id)

      # if @order_item.update(quantity: params["quantity"])
      if @order_item.update(quantity: qty)
        flash[:status] = :success
        flash[:message] = "Updated order id: #{@order_item.id}, order-item quantity now: #{@order_item.quantity}"
        # @order_item.reload
      else
        flash.now[:status] = :error
        flash.now[:message] = "Unable to update"

        # render :edit
      end
    end
    redirect_to order_path(@order_item.order)

  end

  def destroy
    product = params[:id]
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
