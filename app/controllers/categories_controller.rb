class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def create
    name = params["category"]["name"]
    @category = Category.new(name: name)
    successful = @category.save
    if successful
      flash[:status] = :success
      flash[:message] = "Saved category with id #{@category.id} successfully"
    else
      flash[:status] = :error
      flash[:message] = "Could not save the category"
    end
    redirect_to root_path
  end
  
  def index
    @categories = Category.all
  end
end
