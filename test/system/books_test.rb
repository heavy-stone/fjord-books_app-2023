# frozen_string_literal: true

require 'application_system_test_case'

class BooksTest < ApplicationSystemTestCase
  setup do
    user = users(:alice)
    @book = books(:rails_tutorial)

    visit root_url
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'

    assert_text 'ログインしました'
  end

  test 'visiting the index' do
    visit books_url

    assert_selector 'h1', text: '本の一覧'
    assert_text @book.title
    assert_text @book.memo
    assert_text @book.author
    find("img[src='#{@book.picture_url}']")
  end

  test 'should create book' do
    visit books_url
    click_on '本の新規作成'

    assert_selector 'h1', text: '本の新規作成'
    fill_in 'タイトル', with: 'ソフトウェアのテスト技法'
    fill_in 'メモ', with: '色々なテスト技法が身につく！'
    fill_in '著者', with: 'Lee Copeland'
    attach_file '画像', Rails.root.join('test/fixtures/files/images/software.png')
    click_on '登録する'

    assert_selector 'h1', text: '本の詳細'
    assert_text '本が作成されました。'
    click_on '本の一覧に戻る'

    assert_selector 'h1', text: '本の一覧'
  end

  test 'should update Book' do
    visit book_url(@book)

    assert_selector 'h1', text: '本の詳細'
    assert_text @book.title
    assert_text @book.memo
    assert_text @book.author
    find("img[src='#{@book.picture_url}']")
    click_on 'この本を編集'

    assert_selector 'h1', text: '本の編集'
    fill_in 'タイトル', with: 'Ruby on Rails Tutorial'
    fill_in 'メモ', with: "It's difficult, but it's useful!"
    fill_in '著者', with: 'MICHAEL HARTL'
    attach_file '画像', Rails.root.join('test/fixtures/files/images/rails_tutorial2/rails_tutorial.png')
    click_on '更新する'

    assert_selector 'h1', text: '本の詳細'
    assert_text '本が更新されました。'
    book = @book.reload
    assert_text book.title
    assert_text book.memo
    assert_text book.author
    find("img[src='#{book.picture_url}']")
  end

  test 'should destroy Book' do
    visit book_url(@book)
    click_on 'この本を削除'

    assert_selector 'h1', text: '本の一覧'
    assert_text '本が削除されました。'
    assert_no_text @book.title
  end
end
