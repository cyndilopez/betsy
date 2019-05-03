class OrderItemsController < ApplicationController
  def create
    @order = current_order
    
    if @order == nil 
      @order = Order.new
      @order.save 
    end
    
    product = Product.find(params[:product_id])
    
    @order_item = OrderItem.new(params[:product_id], params[:quantity])
    @order_item.order_id = @order.id
      
    if @order_item.save
      session[:order_id] = @order.id
      flash[:status] = :success
      flash[:message] = "Added to cart!"
      redirect_to product_path(@order_item.product_id)
    else
      flash.now[:status] = :error
      flash.now[:message] = "Unable to add to cart :("
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
    params.require(:order_item).permit(:quantity, :product_id)
  end
  
 
end
