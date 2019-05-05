class OrdersController < ApplicationController
  def create
    @order = Order.new(status: params[:status])
  end

  def complete_order
    self.status = "paid"
  end

  private

  def order_params
    params.require(:order).permit(:status)
  end
end
