# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should get name' do
    user = User.new(name: 'John Doe', email: 'foo@example.com')
    assert_equal 'John Doe', user.name_or_email
  end

  test 'should get email' do
    user = User.new(name: '', email: 'foo@example.com')
    assert_equal 'foo@example.com', user.name_or_email
  end
end
