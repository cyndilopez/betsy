class OrdersController < ApplicationController

  def create
    @order = Order.new
    
  end

  private
  
    def order_params
      params.require(:order).permit(:status)
    end
end
