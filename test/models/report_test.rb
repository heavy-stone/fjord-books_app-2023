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
    time = Time.zone.parse('2024-04-26 14:34:43.539077000')
    report = Report.new(created_at: time)
    expected = Date.new(2024, 4, 26)
    assert_equal expected, report.created_on
  end
end
