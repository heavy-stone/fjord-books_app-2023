# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    user = users(:alice)
    @report = reports(:day1_report)

    visit root_url
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'

    assert_text 'ログインしました'
  end

  test 'visiting the index' do
    visit reports_url

    assert_selector 'h1', text: '日報の一覧'
    assert_text @report.title
    assert_text @report.content
    assert_text @report.user.name
    assert_text I18n.l @report.created_on
  end

  test 'should create report' do
    visit reports_url
    click_on '日報の新規作成'

    assert_selector 'h1', text: '日報の新規作成'
    title = '2日目の日報'
    content = '2日目の日報を書きました！'
    fill_in 'タイトル', with: title
    fill_in '内容', with: content
    click_on '登録する'

    assert_selector 'h1', text: '日報の詳細'
    assert_text '日報が作成されました。'
    assert_text title
    assert_text content
    assert_text @report.user.name, count: 2
    assert_text I18n.l @report.created_on
    click_on '日報の一覧に戻る'

    assert_selector 'h1', text: '日報の一覧'
  end

  test 'should update Report' do
    visit report_url(@report)

    assert_selector 'h1', text: '日報の詳細'
    assert_text @report.title
    assert_text @report.content
    assert_text @report.user.name, count: 2
    assert_text I18n.l @report.created_on
    click_on 'この日報を編集'

    assert_selector 'h1', text: '日報の編集'
    fill_in 'タイトル', with: '初日報を書きました！'
    fill_in '内容', with: 'はじめまして！'
    click_on '更新する'

    assert_selector 'h1', text: '日報の詳細'
    assert_text '日報が更新されました。'
    report = @report.reload
    assert_text report.title
    assert_text report.content
    assert_text report.user.name, count: 2
    assert_text I18n.l report.created_on
  end

  test 'should destroy Report' do
    visit report_url(@report)
    click_on 'この日報を削除'

    assert_selector 'h1', text: '日報の一覧'
    assert_text '日報が削除されました。'
    assert_no_text @report.title
  end
end
