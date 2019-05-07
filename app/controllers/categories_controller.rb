class CategoriesController < ApplicationController
  skip_before_action :require_login, only: [:index, :categories]

  def select_categories
    @categories = Category.all
    @product = Product.find_by(id: params["id"])
  end

  def new
    @category = Category.new
  end

  def create
    name = params["name"]
    @category = Category.new(name: name)
    @product = Product.find_by(id: params["product_id"])
    successful = @category.save
    if successful
      flash[:status] = :success
      flash[:message] = "Saved category with id #{@category.id} successfully"
      redirect_to product_categories_path(@product.id)
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
