class CategoriesController < ApplicationController
  layout 'fixed_left'

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
  end
end
