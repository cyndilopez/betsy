class ProductsController < ApplicationController
  def root
  end

  def index
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    successful = @product.save
    if successful
      flash[:status] = :success
      flash[:message] = "Successfully saved #{@product.name} to the database."
      redirect_to_products_path
    else
      flash.now[:status] = :error
      flash.now[:message] = "Could not save product!"
      render :new, status: :bad_request
    end
  end

  def edit
  end

  def update
  end
end
