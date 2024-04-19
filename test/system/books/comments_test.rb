# frozen_string_literal: true

require 'application_system_test_case'

class Books::CommentsTest < ApplicationSystemTestCase
  test 'should create comment' do
    create(:user)
    create(:book)

    visit root_url
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'

    assert_text 'ログインしました'
    click_on 'この本を表示'

    assert_selector 'h1', text: '本の詳細'
    assert_text '(コメントはまだありません)'
    assert_text 'Alice Doe', count: 1
    assert_text '削除', count: 1

    fill_in 'comment[content]', with: 'ためになる本ですね！'
    click_on 'コメントする'

    assert_selector 'h1', text: '本の詳細'
    assert_text 'コメントが作成されました。'
    assert_text 'Alice Doe', count: 2
    assert_text 'ためになる本ですね！'
    assert_text I18n.l(Comment.last.created_at, format: :short)
    assert_text '削除', count: 2
  end

  test 'should create other user comment' do
    user = create(:user)
    book = create(:book)
    comment = create(:book_comment, user:, commentable: book)
    create(:other_user)

    visit root_url
    fill_in 'Eメール', with: 'bob@example.com'
    fill_in 'パスワード', with: 'password123'
    click_on 'ログイン'

    assert_text 'ログインしました'
    click_on 'この本を表示'

    assert_selector 'h1', text: '本の詳細'
    assert_text 'Alice Doe', count: 1
    assert_text '素晴らしい本ですね！'
    assert_text I18n.l(comment.created_at, format: :short)
    assert_text 'Bob Smith', count: 1
    fill_in 'comment[content]', with: 'この本を読んで学習しました！'
    assert_text '削除', count: 1
    click_on 'コメントする'

    assert_selector 'h1', text: '本の詳細'
    assert_text 'Alice Doe', count: 1
    assert_text '素晴らしい本ですね！'
    assert_text I18n.l(comment.created_at, format: :short)
    assert_text 'Bob Smith', count: 2
    assert_text 'この本を読んで学習しました！'
    assert_text I18n.l(Comment.last.created_at, format: :short)
    assert_text '削除', count: 2
  end

  test 'should destroy comment' do
    user = create(:user)
    book = create(:book)
    comment = create(:book_comment, user:, commentable: book)

    visit root_url
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'

    assert_text 'ログインしました'
    click_on 'この本を表示'

    assert_selector 'h1', text: '本の詳細'
    assert_text 'Alice Doe', count: 2
    assert_text '素晴らしい本ですね！'
    assert_text I18n.l(comment.created_at, format: :short)
    assert_text '削除', count: 2
    page.accept_confirm do
      click_on '削除'
    end

    assert_selector 'h1', text: '本の詳細'
    assert_text 'コメントが削除されました。'
    assert_text 'Alice Doe', count: 1
    assert_no_text '素晴らしい本ですね！'
    assert_no_text I18n.l(comment.created_at, format: :short)
    assert_text '削除', count: 2
  end
end
