# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'alice@example.com' }
    name { 'Alice Doe' }
    password { 'password' }
  end

  factory :other_user, class: User do
    email { 'bob@example.com' }
    name { 'Bob Smith' }
    password { 'password123' }
  end
end
