# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test 'should be editable' do
    alice = create(:user)
    report = create(:report, user: alice)
    assert report.editable?(alice)
  end

  test 'should not be editable' do
    alice = create(:user)
    report = create(:report, user: alice)
    bob = create(:user)
    assert_not report.editable?(bob)
  end

  test 'should get created on' do
    time = Time.zone.parse('2024-04-26 14:34:43.539077000')
    report = create(:report, created_at: time)
    expected = Date.new(2024, 4, 26)
    assert_equal expected, report.created_on
  end
end
