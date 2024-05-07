# frozen_string_literal: true

FactoryBot.define do
  factory :book_comment, class: Comment do
    sequence(:content) { "本のコメント#{_1}" }
    user
    association :commentable, factory: :book
  end

  factory :report_comment, class: Comment do
    sequence(:content) { "日報のコメント#{_1}" }
    user
    association :commentable, factory: :report
  end
end
