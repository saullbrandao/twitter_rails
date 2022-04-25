class TweetsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @tweet = current_user.tweets.build(tweet_params)
    @tweet.image.attach(params[:tweet][:image])
    if @tweet.save
      flash[:success] = "Tweet created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    @tweet.destroy
    flash[:success] = "Tweet deleted"
    redirect_back(fallback_location: root_url)
  end

  private

    def tweet_params
      params.require(:tweet).permit(:content, :image)
    end

    def correct_user
      @tweet = current_user.tweets.find_by(id: params[:id])
      redirect_to root_url if @tweet.nil?
    end
end
