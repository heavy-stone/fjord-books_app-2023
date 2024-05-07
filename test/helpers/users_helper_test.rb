# frozen_string_literal: true

require 'test_helper'

class UsersHelperTest < ActionView::TestCase
  test 'should return user name or email' do
    alice = create(:user, name: 'Alice Doe', email: 'alice@example.com')
    assert_equal 'Alice Doe', current_user_name(alice)
    alice.name = ''
    assert_equal 'alice@example.com', current_user_name(alice)
  end
end
