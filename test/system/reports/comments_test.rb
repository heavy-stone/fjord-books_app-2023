# frozen_string_literal: true

require 'application_system_test_case'

class Reports::CommentsTest < ApplicationSystemTestCase
  setup do
    @alice = create(:user, email: 'alice@example.com', name: 'Alice Doe', password: 'password')
    @report = create(:report)
  end

  test 'should create comment' do
    visit root_url
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'

    assert_text 'ログインしました'
    visit report_url(@report)

    assert_selector 'h1', text: '日報の詳細'
    assert_text '(コメントはまだありません)'
    assert_text 'Alice Doe', count: 1
    assert_text '削除', count: 0
    fill_in 'comment[content]', with: 'すごくいい取り組みですね！'
    click_on 'コメントする'

    assert_selector 'h1', text: '日報の詳細'
    assert_text 'コメントが作成されました。'
    assert_text 'Alice Doe', count: 2
    assert_text 'すごくいい取り組みですね！'
    assert_text I18n.l(Comment.last.created_at, format: :short)
    assert_text '削除', count: 1
  end

  test 'should create other user comment' do
    alice_commented_at = Time.zone.parse('2023-03-25 13:33:42.428966999')
    alice_comment = create(:report_comment, content: 'すごくいい取り組みですね！', user: @alice, commentable: @report, created_at: alice_commented_at)
    create(:user, email: 'bob@example.com', name: 'Bob Smith', password: 'password123')

    visit root_url
    fill_in 'Eメール', with: 'bob@example.com'
    fill_in 'パスワード', with: 'password123'
    click_on 'ログイン'

    assert_text 'ログインしました'
    visit report_url(@report)

    assert_selector 'h1', text: '日報の詳細'
    assert_text 'Alice Doe', count: 1
    assert_text 'すごくいい取り組みですね！'
    assert_text I18n.l(alice_comment.created_at, format: :short)
    assert_text '削除', count: 0
    assert_text 'Bob Smith', count: 1
    fill_in 'comment[content]', with: 'このまま頑張りましょう！'
    click_on 'コメントする'

    assert_selector 'h1', text: 'の詳細'
    assert_text 'Alice Doe', count: 1
    assert_text 'すごくいい取り組みですね！'
    assert_text I18n.l(alice_comment.created_at, format: :short)
    assert_text 'Bob Smith', count: 2
    assert_text 'このまま頑張りましょう！'
    assert_text I18n.l(Comment.last.created_at, format: :short)
    assert_text '削除', count: 1
  end

  test 'should destroy comment' do
    alice_commented_at = Time.zone.parse('2023-03-25 13:33:42.428966999')
    create(:report_comment, content: 'すごくいい取り組みですね！', user: @alice, commentable: @report, created_at: alice_commented_at)

    visit root_url
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'

    assert_text 'ログインしました'
    visit report_path(@report)

    assert_selector 'h1', text: '日報の詳細'
    assert_text 'すごくいい取り組みですね！'
    assert_text '削除', count: 1
    page.accept_confirm do
      click_on '削除'
    end

    assert_selector 'h1', text: '日報の詳細'
    assert_text 'コメントが削除されました。'
    assert_no_text 'すごくいい取り組みですね！'
    assert_text '削除', count: 1
  end
end
