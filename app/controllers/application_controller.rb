class ApplicationController < ActionController::Base
  def current_order
    if session[:order_id]
      Order.find_by(id: session[:order_id])
    else
      Order.new
    end
  end
end
