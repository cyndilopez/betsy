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
  end

  def create
  end

  def edit
  end

  def update
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :photoURL, :stock, :merchant_id)
  end
end
