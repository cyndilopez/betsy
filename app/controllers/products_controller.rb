class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update]
  skip_before_action :require_login, only: [:root, :index, :show]

  def root
  end

  def index
    # if params[:category]
    #   @products = Product.where(:category => params[:category])
    #   if @products.empty?
    #     flash[:error] = "Sorry, no products in this category"
    #   else
    #     flash[:notice] = "#{@products.count} in this category"
    #   end
    # else
    @products = Product.all.select { |p| p.active }
    # end
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
      # redirect_to product_select_categories_path(@product.id)
      redirect_to merchant_path(@product.merchant)
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

    unless session[:merchant_id] == @product.merchant_id
      flash[:status] = :error
      flash[:message] = "You don't have permission to edit this product."
      redirect_to root_path
    end
  end

  def update
    # @product = Product.find_by(id: params[:id])

    # unless @product
    #   head :not_found
    #   return
    # end
    order_item_update = params["order_item"]

    if @product.update(product_params)
      flash[:status] = :success
      flash[:message] = "Successfully updated product #{@product.name}"

      redirect_to merchant_path(@product.merchant)
    else
      flash.now[:status] = :error
      flash.now[:message] = "Could not save product #{@product.name}"

      render :edit, status: :bad_request
    end
  end

  def update_status
    product_id = params[:id].to_i
    @product = Product.find_by(id: product_id)

    if @product.nil?
      head :not_found
      return
    end

    unless session[:merchant_id] == @product.merchant_id
      flash[:status] = :error
      flash[:message] = "You don't have permission to edit this merchant's product."
      redirect_to root_path
      return
    end

    if !@product.active
      @product.active = true
    else
      @product.active = false
    end

    @product.save

    redirect_to merchant_path(Merchant.find_by(id: session[:merchant_id]))
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :photoURL, :stock, :merchant_id, category_ids: [])
  end

  # def select_active_products
  #   products = Product.all
  #   @products = products.select { |p| p.active }
  # end
end
