# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'alice@example.com' }
    name { 'Alice Doe' }
    password { 'password' }
  end
end
