require "test_helper"

class TweetTest < ActiveSupport::TestCase
  def setup 
    @user = users(:john)
    @tweet = @user.tweets.build(content: "This is a test tweet")
  end

  test "should be valid" do
    assert @tweet.valid?
  end

  test "user id should be present" do
    @tweet.user_id = nil
    assert_not @tweet.valid?
  end

  test "content should be present" do
    @tweet.content = "   "
    assert_not @tweet.valid?
  end

  test "content should be at most 140 characters" do
    @tweet.content = "a" * 141
    assert_not @tweet.valid?
  end

  test "order should be most recent first" do
    assert_equal tweets(:most_recent), Tweet.first
  end
end
