class EntriesController < ApplicationController
  def index
    @entries = Entry.order('published desc')
  end

  def show
    @entry = Entry.find(params[:id])
  end
end
