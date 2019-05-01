class ProductsController < ApplicationController
  def root
  end

  def index
    @products = Product.all
  end

  def show
    @product = Product.find_by(id: params[:id])

    if @product
      product_id = @product.id
      redirect_to product_path(product_id)
    else
      raise ActionController::RoutingError.new("Not Found")
    end
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
      redirect_to products_path
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

  def product_params
    params.require(:product).permit(:name, :description, :price, :photoURL, :stock, :merchant_id)
  end
end
