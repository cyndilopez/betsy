class ReviewsController < ApplicationController
  skip_before_action :require_login

  def new
    @product = Product.find_by(id: params[:product_id])
    unless @product
      head :not_found
    end
    if session[:merchant_id]
      if session[:merchant_id] == @product.merchant.id
        flash[:status] = :error
        flash[:message] = "You can't review your own product!"
        redirect_to product_path(@product.id)
      end
    else
      @review = Review.new
    end
  end

  def create
    @product = Product.find_by(id: params[:product_id])
    unless @product
      head :not_found
      return
    end
    if session[:merchant_id] == @product.merchant.id
      flash.now[:status] = :error
      flash.now[:message] = "You can't review your own product!"
      redirect_to product_path(@product.id)
    else
      @review = Review.new(review_params)
      @review.product = @product
      successful = @review.save
      p successful
      if @review.save
        flash[:status] = :success
        flash[:message] = "Your review was added succesfully!"
        redirect_to product_path(@review.product_id)
      else
        flash[:status] = :error
        flash[:message] = "Couldn't save review: #{@review.errors.messages}"
        render :new, status: :bad_request
      end
    end
  end

  def review_params
    params.require(:review).permit(:rating, :comment, :name)
  end
end
