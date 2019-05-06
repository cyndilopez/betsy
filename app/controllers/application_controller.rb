class ApplicationController < ActionController::Base
  before_action :require_login

  def find_product
    @product = Product.find_by(id: params[:id])
    unless @product
      head :not_found
      return
    end
  end

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
    end
  end

  def current_merchant
    merchant_id = session[:merchant_id]
    merchant = Merchant.find_by(id: merchant_id)
    return merchant
  end
end
