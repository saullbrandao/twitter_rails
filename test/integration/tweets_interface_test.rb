require "test_helper"

class TweetsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john)
  end

  test "tweet interface" do
    log_in_as @user
    get root_path
    assert_select "div.pagination"
    assert_select "input[type=file]"

    # Invalid submission
    assert_no_difference "Tweet.count" do
      post tweets_path, params: { tweet: { content: "" } }
    end
    assert_select "div#error_explanation"
    assert_select 'a[href=?]', '/?page=2'

    # Valid submission
    content = "This tweet really ties the room together"
    image = fixture_file_upload("test/fixtures/kitten.jpg", "image/jpeg")
    assert_difference 'Tweet.count', 1 do
      post tweets_path, params: { tweet: { content: content, image: image } }
    end
    assert assigns(:tweet).image.attached?
    follow_redirect!
    assert_match content, response.body

    # Delete a tweet
    assert_select 'a', text: 'delete'
    first_tweet = @user.tweets.paginate(page: 1).first
    assert_difference 'Tweet.count', -1 do
      delete tweet_path(first_tweet)
    end

    # Visit different user (no delete links)
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end

  test "tweet sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.tweets.count} tweets", response.body

    # User with zero tweets
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match "0 tweets", response.body
    other_user.tweets.create!(content: "A tweet")
    get root_path
    assert_match "1 tweet", response.body
  end
end
