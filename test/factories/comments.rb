# frozen_string_literal: true

FactoryBot.define do
  factory :book_comment, class: Comment do
    content { '素晴らしい本ですね！' }
    user
    association :commentable, factory: :book
  end
end
