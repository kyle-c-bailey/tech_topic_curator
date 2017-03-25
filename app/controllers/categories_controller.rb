class CategoriesController < ApplicationController
  def index
    @categories = Category.order('created_at desc')
    @category = Category.new
  end

  def show
    @category = Category.find(params[:id])
  end

  def create
    file = params[:category][:category_file]

    file_name = File.basename(file.original_filename ,File.extname(file.original_filename))
    Category.where(name: file_name).destroy_all
    category = Category.create!(name: file_name)

    file_contents = file.read
    file_contents.gsub!(/\r\n?/, "\n")

    file_contents.each_line do |line|
      Item.create!(category_id: category.id, name: line.gsub("\n",''))
    end

    redirect_to categories_path
  end
end
