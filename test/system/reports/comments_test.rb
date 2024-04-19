# frozen_string_literal: true

require 'application_system_test_case'

class Reports::CommentsTest < ApplicationSystemTestCase
  test 'should create comment' do
    create(:report)

    visit root_url
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'

    assert_text 'ログインしました'
    click_on '日報'

    assert_selector 'h1', text: '日報の一覧'
    click_on 'この日報を表示'

    assert_selector 'h1', text: '日報の詳細'
    assert_text '(コメントはまだありません)'
    assert_text 'Alice Doe', count: 2
    assert_text '削除', count: 1

    fill_in 'comment[content]', with: '初めての日報を書きました！'
    click_on 'コメントする'

    assert_selector 'h1', text: '日報の詳細'
    assert_text 'コメントが作成されました。'
    assert_text 'Alice Doe', count: 3
    assert_text '初めての日報を書きました！'
    assert_text I18n.l(Comment.last.created_at, format: :short)
    assert_text '削除', count: 2
  end

  test 'should create other user comment' do
    report = create(:report)
    comment = create(:report_comment, user: report.user, commentable: report)
    create(:other_user)

    visit root_url
    fill_in 'Eメール', with: 'bob@example.com'
    fill_in 'パスワード', with: 'password123'
    click_on 'ログイン'

    assert_text 'ログインしました'
    click_on '日報'

    assert_selector 'h1', text: '日報の一覧'
    click_on 'この日報を表示'

    assert_selector 'h1', text: '日報の詳細'
    assert_text 'Alice Doe', count: 2
    assert_text '日報書きました！'
    assert_text I18n.l(comment.created_at, format: :short)
    assert_text '削除', count: 0
    assert_text 'Bob Smith', count: 1
    fill_in 'comment[content]', with: 'このまま頑張りましょう！'
    click_on 'コメントする'

    assert_selector 'h1', text: 'の詳細'
    assert_text 'Alice Doe', count: 2
    assert_text '日報書きました！'
    assert_text I18n.l(comment.created_at, format: :short)
    assert_text 'Bob Smith', count: 2
    assert_text 'このまま頑張りましょう！'
    assert_text I18n.l(Comment.last.created_at, format: :short)
    assert_text '削除', count: 1
  end

  test 'should destroy comment' do
    report = create(:report)
    comment = create(:report_comment, user: report.user, commentable: report)

    visit root_url
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'

    assert_text 'ログインしました'
    click_on '日報'

    assert_selector 'h1', text: '日報の一覧'
    click_on 'この日報を表示'

    assert_selector 'h1', text: '日報の詳細'
    assert_text 'Alice Doe', count: 3
    assert_text '日報書きました！'
    assert_text I18n.l(comment.created_at, format: :short)
    assert_text '削除', count: 2
    page.accept_confirm do
      click_on '削除'
    end

    assert_selector 'h1', text: '日報の詳細'
    assert_text 'コメントが削除されました。'
    assert_text 'Alice Doe', count: 2
    assert_no_text '日報書きました！'
    assert_no_text I18n.l(comment.created_at, format: :short)
    assert_text '削除', count: 2
  end
end
