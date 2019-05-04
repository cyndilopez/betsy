class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def create
    name = params["category"]["name"]
    p name
    p current_merchant
    @category = Category.new(name: name)
    successful = @category.save
    p @category.valid?
    if successful
      flash[:status] = :success
      flash[:message] = "Saved category with id #{@category.id} successfully"
    else
      flash[:status] = :error
      flash[:message] = "Could not save the category"
    end
    redirect_to root_path
  end
end
