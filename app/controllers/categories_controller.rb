class CategoriesController < ApplicationController
  skip_before_action :require_login, only: [:index, :categories]

  def index
    @categories = Category.order(name: :asc)
  end

  def select_categories
    @categories = Category.all
    @product = Product.find_by(id: params["id"])
  end

  def new
    @category = Category.new
  end

  def create
    if params["product_id"]
      name = params["name"]
    else
      name = params["category"]["name"]
    end
    @category = Category.new(name: name)
    @product = Product.find_by(id: params["product_id"])
    successful = @category.save
    if successful
      flash[:status] = :success
      flash[:message] = "Saved category with id #{@category.id} successfully"
      if params["product_id"]
        redirect_to edit_product_path(@product.id)
      else
        redirect_to new_product_path
      end
    else
      flash[:status] = :error
      flash[:message] = "Could not save the category: #{@category.errors.messages}"
      redirect_to root_path
    end
  end

  def categories
    @category = Category.find_by(id: params[:id])
    if @category
      @products_by_categories = Category.filter_by_category(params)
    else
      head :not_found
    end
  end
end
