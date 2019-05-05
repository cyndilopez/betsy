class OrdersController < ApplicationController
  def create
    @order = Order.new(status: params[:status])
    if @order.save
      redirect_to order_path(@order_id)
    else
      flash.now[:status] = :error
      flash.now[:message] = "Unable to save order"
      render :edit
    end
  end

  def update
    @order.update(order_params)
    @order.complete_order

    if @order.save
      # refresh to delete cc data
      flash[:status] = :success
      flash[:message] = "Thanks for shopping with us! Please save your order number - ##{@order.id}."
      redirect_to order_path(@order.id)
    else
      flash[:alert] = @order.errors
      render :edit
    end
  end

  private

  def find_order
    @order = Order.find_by(id: params[:id])
    render_404 unless @order
  end

  def complete_order
    self.status = "paid"
  end

  def order_params
    params.require(:order).permit(:status)
  end
end
