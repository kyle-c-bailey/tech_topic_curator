class ContextCategoriesController < ApplicationController
  before_action :set_context, only: [:show, :destroy]

  def index
    @contexts = ContextCategory.order('created_at desc')
    @context = ContextCategory.new
  end

  def show
  end

  def destroy
    @context.destroy
    redirect_to context_categories_path, notice: 'Context was successfully destroyed.'
  end

  def create
    file = params[:context_category][:context_file]

    file_name = File.basename(file.original_filename ,File.extname(file.original_filename))
    ContextCategory.where(name: file_name).destroy_all
    context = ContextCategory.create!(name: file_name)

    file_contents = file.read
    file_contents.gsub!(/\r\n?/, "\n")

    file_contents.each_line do |line|
      ContextWord.create!(context_category_id: context.id, name: line.gsub("\n",''))
    end

    redirect_to context_categories_path
  end

  private

  def set_context
    @context = ContextCategory.find(params[:id])
  end
end
