class FeedsController < ApplicationController
  before_action :set_feed, only: [:show, :edit, :update, :destroy, :entries]

  def index
    @feeds = Feed.all
  end

  def show
  end

  def entries
    @entries = @feed.entries.order('published desc')
  end

  def new
    @feed = Feed.new
  end

  def edit
  end

  def create
    @feed = Feed.new(feed_params)

    respond_to do |format|
      if @feed.save
        format.html { redirect_to @feed, notice: 'Feed was successfully created.' }
        format.json { render :show, status: :created, location: @feed }
      else
        format.html { render :new }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @feed.update(feed_params)
        format.html { redirect_to @feed, notice: 'Feed was successfully updated.' }
        format.json { render :show, status: :ok, location: @feed }
      else
        format.html { render :edit }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @feed.destroy
    respond_to do |format|
      format.html { redirect_to feeds_url, notice: 'Feed was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def word_aggregator
    #@phrases = Phrase.joins(:phrase_entries).group("phrases.id").order("count(phrases.id) desc")
    @phrases = Phrase.joins(:phrase_entries).group("phrases.id").order("RANDOM()")
  end

  def clear_entries
    Entry.destroy_all
    redirect_to feeds_path
  end

  private
    def set_feed
      @feed = Feed.find(params[:id])
    end

    def feed_params
      params.require(:feed).permit(:name, :url, :description)
    end
end
