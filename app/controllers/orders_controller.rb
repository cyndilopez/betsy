class OrdersController < ApplicationController
  skip_before_action :require_login
  before_action :find_order

  def show
    @order_items = @order.order_items.order(:created_at)
  end

  def update
    @order.update(order_params)
    @order.status = "paid"
    successful = @order.save
    p @order.errors.messages
    if successful
      flash[:status] = :success
      flash[:message] = "Thanks for shopping with us! Please save your order number - ##{@order.id}."
      @order.product_update
      redirect_to order_confirmation_path(@order)
      session[:order_id] = nil
    else
      flash[:status] = :error
      err = []
      error_messages = @order.errors.messages.each { |name, probs| probs.each { |problem| err << "#{name}: #{problem}" } }
      flash[:message] = "Can't checkout, " + err[0].to_s.upcase
      redirect_to root_path
    end

    def confirmation
      @order_items = @order.order_items
    end
  end

  private

  def order_params
    params.require(:order).permit(
      :status,
      :name,
      :email,
      :address,
      :cc_num,
      :cc_cvv,
      :cc_expiration,
      :zip_code
    )
  end

  def find_order
    @order = Order.find_by(id: params[:id])
    unless @order
      head :not_found
    end
  end
end
