# frozen_string_literal: true

require 'test_helper'

class UsersHelperTest < ActionView::TestCase
  test 'should return user name or email' do
    user = build(:user)
    assert_equal 'Alice Doe', current_user_name(user)
    user.name = ''
    assert_equal 'alice@example.com', current_user_name(user)
  end
end
