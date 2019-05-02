class ApplicationController < ActionController::Base
  before_action :require_login

  def require_login
    if !session[:merchant_id]
      flash[:status] = :error
      flash[:message] = "You must be logged in to use this page."
      redirect_to root_path
    end
  end

  def current_order
    if session[:order_id]
      Order.find_by(id: session[:order_id])
    else
      Order.new
    end
  end
end
