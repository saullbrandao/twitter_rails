require "test_helper"

class TweetsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @tweet = tweets(:orange)
  end

  test "should redirect create when not logged in" do
    assert_no_difference "Tweet.count" do
      post tweets_path, params: { tweet: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference "Tweet.count" do
      delete tweet_path(@tweet)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong tweet" do
    log_in_as(users(:john))
    
    tweet = tweets(:ants)
    assert_no_difference "Tweet.count" do
      delete tweet_path(tweet)
    end
    assert_redirected_to root_url
  end
end
