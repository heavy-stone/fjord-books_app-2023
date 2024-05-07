# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should get name' do
    alice = create(:user, name: 'Alice Doe', email: 'alice@example.com')
    assert_equal 'Alice Doe', alice.name_or_email
  end

  test 'should get email' do
    alice = create(:user, name: '', email: 'alice@example.com')
    assert_equal 'alice@example.com', alice.name_or_email
  end
end
