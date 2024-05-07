# frozen_string_literal: true

require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'should pluralize' do
    assert_equal 'book', i18n_pluralize('book')
    I18n.locale = :en
    assert_equal 'books', i18n_pluralize('book')
    I18n.locale = :ja
  end

  test 'should show error count' do
    assert_equal '3件のエラー', i18n_error_count(3)
    I18n.locale = :en
    assert_equal '3 errors', i18n_error_count(3)
    I18n.locale = :ja
  end

  test 'should format content' do
    assert_equal 'Hello<br>World', format_content("Hello\nWorld")
  end
end
