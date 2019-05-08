class ReviewsController < ApplicationController
  def new
    @product = Product.find_by(id: params[:product_id])
    if !@merchant.nil? && @merchant.id == @product.merchant.id
      flash[:error] = "You can't review your own product!"
      redirect_to product_path(@product.id)
    else
      unless @product
        head :not_found 
      end
      @review = Review.new
    end
  end

  def create
    @product = Product.find_by(id: params[:product_id])
    unless @product
      head :not_found
    end
    if !@merchant.nil? && @merchant.id == @product.merchant.id
      flash.now[:error] = "You can't review your own product!"
      redirect_to product_path(@product.id)
    else
      @review = Review.new(review_params)
      if @review.save
        flash[:success] = "Your review was added succesfully!"
        redirect_to product_path(@review.product_id)
      else
        flash[:status] = :error
        flash[:message] = "Couldn't save review: #{@review.errors.messages}"
        render :new, status: :bad_request
      end
    end
  end

  def review_params
    params.permit(:rating, :comment, :product_id)
  end
end
