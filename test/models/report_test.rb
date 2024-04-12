# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test 'should be editable' do
    user = User.new
    report = user.reports.new
    assert report.editable?(user)
  end

  test 'should not be editable' do
    user1 = User.new
    user2 = User.new
    report = user1.reports.new
    assert_not report.editable?(user2)
  end

  test 'should get created on' do
    now = Time.current
    report = Report.new(created_at: now)
    assert_equal now.to_date, report.created_on
  end
end
