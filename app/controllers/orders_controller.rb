class OrdersController < ApplicationController
  skip_before_action :require_login
  before_action :find_order

  def show
    @order_items = @order.order_items
  end

  def update
    @order.update(order_params)
    @order.status = "paid"
    successful = @order.save
    if successful
      flash[:status] = :success
      flash[:message] = "Thanks for shopping with us! Please save your order number - ##{@order.id}."
      @order.product_update
      redirect_to order_confirmation_path(@order)
      session[:order_id] = nil
    else
      flash[:status] = :error
      flash[:message] = "Can't checkout, #{@order.errors.messages}"
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
    render_404 unless @order
  end
end
