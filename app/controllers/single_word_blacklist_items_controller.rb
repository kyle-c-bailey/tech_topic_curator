class SingleWordBlacklistItemsController < ApplicationController
  def index
    @items = SingleWordBlackListItem.all
  end

  def batch_create
    file = params[:blacklist_file]

    SingleWordBlackListItem.destroy_all

    file_contents = file.read
    file_contents.gsub!(/\r\n?/, "\n")

    file_contents.each_line do |line|
      SingleWordBlackListItem.create!(phrase: line.gsub("\n",''))
    end

    redirect_to single_word_blacklist_items_path
  end
end
