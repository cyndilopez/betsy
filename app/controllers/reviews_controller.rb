class ReviewsController < ApplicationController
  def new
    @product = Product.find_by(id: params[:product_id])
    if !@merchant.nil? && @merchant.id == @product.merchant.id
      flash[:error] = "You can't review your own product!"
      redirect_to product_path(@product.id)
    else
      render_404 unless @product
      @review = Review.new
    end
  end

  def review_params
    params.permit(:rating, :comment, :product_id)
  end
end
