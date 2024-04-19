# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = create(:report)

    visit root_url
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'

    assert_text 'ログインしました'
  end

  test 'visiting the index' do
    visit reports_url

    assert_selector 'h1', text: '日報の一覧'
    assert_text '初日報'
    assert_text '初めての日報です。'
    assert_text 'Alice Doe'
    assert_text I18n.l @report.created_on
  end

  test 'should create report' do
    visit reports_url
    click_on '日報の新規作成'

    assert_selector 'h1', text: '日報の新規作成'
    fill_in 'タイトル', with: '2日目の日報'
    fill_in '内容', with: '2日目の日報を書きました！'
    click_on '登録する'

    assert_selector 'h1', text: '日報の詳細'
    assert_text '日報が作成されました。'
    assert_text '2日目の日報'
    assert_text '2日目の日報を書きました！'
    assert_text 'Alice Doe', count: 2
    assert_text I18n.l @report.created_on
    click_on '日報の一覧に戻る'

    assert_selector 'h1', text: '日報の一覧'
  end

  test 'should update Report' do
    visit report_url(@report)

    assert_selector 'h1', text: '日報の詳細'
    assert_text '初日報'
    assert_text '初めての日報です。'
    assert_text 'Alice Doe', count: 2
    assert_text I18n.l @report.created_on
    click_on 'この日報を編集'

    assert_selector 'h1', text: '日報の編集'
    fill_in 'タイトル', with: '初日報を書きました！'
    fill_in '内容', with: 'はじめまして！'
    click_on '更新する'

    assert_selector 'h1', text: '日報の詳細'
    assert_text '日報が更新されました。'
    assert_text '初日報を書きました！'
    assert_text 'はじめまして！'
    assert_text 'Alice Doe', count: 2
    assert_text I18n.l @report.reload.created_on
  end

  test 'should destroy Report' do
    visit report_url(@report)
    click_on 'この日報を削除'

    assert_selector 'h1', text: '日報の一覧'
    assert_text '日報が削除されました。'
    assert_no_text '初日報を書きました！'
  end

  test 'should create report with report mention' do
    visit reports_url
    click_on 'この日報を表示'

    assert_selector 'h1', text: '日報の詳細'
    assert_text '初日報'
    assert_text 'Alice Doe', count: 2
    assert_text '（この日報に言及している日報はまだありません）'
    click_on '日報の一覧に戻る'

    assert_selector 'h1', text: '日報の一覧'
    click_on '日報の新規作成'

    assert_selector 'h1', text: '日報の新規作成'
    fill_in 'タイトル', with: '2日目の日報'
    fill_in '内容', with: "こちらの日報を参考にしました。\nhttp://localhost:3000/reports/1"
    click_on '登録する'

    assert_selector 'h1', text: '日報の詳細'
    assert_text '日報が作成されました。'
    assert_text '2日目の日報'
    assert_text "こちらの日報を参考にしました。\nhttp://localhost:3000/reports/1"
    assert_text I18n.l @report.created_on
    click_on '日報の一覧に戻る'

    assert_selector 'h1', text: '日報の一覧'
    find(:xpath, "(//a[text()='この日報を表示'])[2]").click

    assert_selector 'h1', text: '日報の詳細'
    assert_text '初日報'
    assert_no_text '（この日報に言及している日報はまだありません）'
    assert_text '2日目の日報'
    assert_text 'Alice Doe', count: 3
    assert_text I18n.l @report.mentioned_reports.first.created_on
  end
end
