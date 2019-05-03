class OrdersController < ApplicationController
  skip_before_action :require_login

  def create
    @order = Order.new
  end

  private

  def order_params
    params.require(:order).permit(:status)
  end
end
