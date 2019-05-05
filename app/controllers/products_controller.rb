class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update]
  skip_before_action :require_login, only: [:root, :index, :show]

  def root
  end

  def index
    if params[:category]
      @products = Product.where(:category => params[:category])
      if @products.empty?
        flash[:error] = "Sorry, no products in this category"
      else
        flash[:notice] = "#{@products.count} in this category"
      end
    else
      @products = Product.all
    end 
  end

  def show
    # @product = Product.find_by(id: params[:id])

    # if @product
    #   product_id = @product.id
    # else
    #   head :not_found
    # end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.merchant_id = session[:merchant_id]
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
    # @product = Product.find_by(id: params[:id])

    # unless @product
    #   head :not_found
    # end
  end

  def update
    # @product = Product.find_by(id: params[:id])

    # unless @product
    #   head :not_found
    #   return
    # end

    if @product.update(product_params)
      flash[:status] = :success
      flash[:message] = "Successfully updated product #{@product.name}"

      redirect_to product_path(@product)
    else
      flash.now[:status] = :error
      flash.now[:message] = "Could not save product #{@product.name}"

      render :edit, status: :bad_request
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :photoURL, :stock, :merchant_id, category_ids: [])
  end
end
