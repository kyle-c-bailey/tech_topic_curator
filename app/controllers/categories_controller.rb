class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :destroy]

  def index
    @categories = Category.order('created_at desc')
    @category = Category.new
  end

  def show
  end

  def destroy
    @category.destroy
    redirect_to categories_url, notice: 'Category was successfully destroyed.'
  end

  def create
    file = params[:category][:category_file]

    file_name = params[:category][:name]
    return if file_name.empty?
    priority = params[:category][:priority].present? ? params[:category][:priority] : 3

    Category.where(name: file_name).destroy_all
    category = Category.create!(name: file_name, priority: priority)

    file_contents = file.read
    file_contents.gsub!(/\r\n?/, "\n")

    file_contents.each_line do |line|
      Item.create!(category_id: category.id, name: line.gsub("\n",''))
    end

    redirect_to categories_path
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end
end
