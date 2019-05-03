class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def create
    name = params[:name]
    @category = Category.new(name: name)
    @category.save
    if @category
      flash[:status] = :success
      flash[:message] = "Saved category with id #{category.id} successfully"
    else
      flash[:status] = :error
      flash[:message] = "Could not save the category"
    end
  end
end
