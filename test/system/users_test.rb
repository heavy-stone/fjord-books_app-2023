# frozen_string_literal: true

require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase
  test 'should create user' do
    visit new_user_registration_url

    assert_selector 'h2', text: 'アカウント登録'
    fill_in 'Eメール', with: 'bob@example.com'
    fill_in '氏名', with: 'Bob Smith'
    fill_in '郵便番号', with: '223-4567'
    fill_in '住所', with: 'Osaka'
    fill_in '自己紹介文', with: 'ボブです。よろしく！'
    attach_file 'ユーザ画像', Rails.root.join('test/fixtures/files/images/bob.jpg')
    fill_in 'パスワード', with: 'password'
    fill_in 'パスワード（確認用）', with: 'password'
    click_on 'アカウント登録'

    assert_selector 'h1', text: '本の一覧'
    assert_text 'アカウント登録が完了しました。'
    click_on 'Bob Smith'

    assert_selector 'h1', text: 'ユーザの詳細'
    assert_text 'bob@example.com'
    assert_text 'Bob Smith'
    assert_text '223-4567'
    assert_text 'Osaka'
    assert_text 'ボブです。よろしく！'
    assert User.last.avatar.attached?
  end

  test 'should update user without password' do
    user = create(:user)

    visit root_url
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'

    assert_text 'ログインしました'
    click_on 'Alice Doe'

    assert_selector 'h1', text: 'ユーザの詳細'
    click_on 'このユーザを編集'

    assert_selector 'h2', text: 'アカウント編集'
    fill_in 'Eメール', with: 'alice_smith@example.com'
    fill_in '氏名', with: 'Alice Smith'
    fill_in '郵便番号', with: '987-6543'
    fill_in '住所', with: 'New York'
    fill_in '自己紹介文', with: 'Hello, I am Alice!'
    attach_file 'ユーザ画像', Rails.root.join('test/fixtures/files/images/alice.jpg')
    fill_in '現在のパスワード', with: 'password'
    click_on '更新'

    assert_selector 'h2', text: 'アカウント編集'
    assert_text 'alice_smith@example.com'
    assert_text 'Alice Smith'
    assert_text '987-6543'
    assert_text 'New York'
    assert_text 'Hello, I am Alice!'
    assert user.reload.avatar.attached?
  end

  test 'should update user password and logout and login' do
    create(:user)

    visit root_url
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'

    assert_text 'ログインしました'
    click_on 'Alice Doe'

    assert_selector 'h1', text: 'ユーザの詳細'
    click_on 'このユーザを編集'

    assert_selector 'h2', text: 'アカウント編集'
    fill_in 'パスワード', with: 'password123'
    fill_in 'パスワード（確認用）', with: 'password123'
    fill_in '現在のパスワード', with: 'password'
    click_on '更新'

    assert_selector 'h1', text: 'ユーザの詳細'
    assert_text 'アカウント情報を変更しました。'
    click_on 'ログアウト'

    assert_selector 'h2', text: 'ログイン'
    assert_text 'ログアウトしました。'
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password123'
    click_on 'ログイン'

    assert_selector 'h1', text: '本の一覧'
    assert_text 'ログインしました'
  end

  test 'should destroy user' do
    create(:user)
    user_count = User.count

    visit root_url
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'

    assert_text 'ログインしました'
    click_on 'Alice Doe'

    assert_selector 'h1', text: 'ユーザの詳細'
    click_on 'このユーザを編集'

    assert_selector 'h2', text: 'アカウント編集'
    page.accept_confirm do
      click_on 'アカウント削除'
    end

    assert_selector 'h2', text: 'ログイン'
    assert_text 'アカウントを削除しました。またのご利用をお待ちしております。'
    assert User.count, user_count - 1
  end

  test 'should reset password' do
    create(:user)
    visit root_url
    click_on 'パスワードを忘れましたか？'

    assert_selector 'h2', text: 'パスワードを忘れましたか？'
    fill_in 'Eメール', with: 'alice@example.com'
    click_on 'パスワードの再設定方法を送信する'

    assert_selector 'h2', text: 'ログイン'
    assert_text 'パスワードの再設定について数分以内にメールでご連絡いたします。'

    mail = ActionMailer::Base.deliveries.last
    url = mail.body.encoded[/http[^"]+/]
    visit url

    assert_selector 'h2', text: 'パスワードを変更'
    fill_in '新しいパスワード', with: 'password123'
    fill_in '確認用新しいパスワード', with: 'password123'
    click_on 'パスワードを変更する'

    assert_selector 'h1', text: '本の一覧'
    assert_text 'パスワードが正しく変更されました。'
  end
end
