require "test_helper"

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:john)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.tweets.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    @user.tweets.paginate(page: 1).each do |tweet|
      assert_match tweet.content, response.body
    end
  end
end
