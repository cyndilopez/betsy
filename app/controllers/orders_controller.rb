class OrdersController < ApplicationController
  before_action :find_order, except: [:create]

  def show
    @order_items = @order.order_items
  end

  # def create # ??????
  #   @order = Order.new(status: params[:status])
  #   if @order.save
  #     redirect_to order_path(@order_id)
  #   else
  #     flash.now[:status] = :error
  #     flash.now[:message] = "Unable to save order"
  #     render :edit
  #   end
  # end

  def update #complete order
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

  def destroy # or can ibe update to change status to cancel
    @order.destroy
    # @order.status = 'cancelled'
    flash[:status] = :success
    flash[:message] = "Your order has been cancelled."
    redirect_to root_path
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
      :cc_expiration
    )
  end

  def find_order
    @order = Order.find_by(id: params[:id])
    render_404 unless @order
  end

  def complete_order
    self.status = "paid"
  end
end
