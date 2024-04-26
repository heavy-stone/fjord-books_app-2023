# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    user
    sequence(:title) { "日報のタイトル#{_1}" }
    sequence(:content) { "日報の内容#{_1}" }
  end
end
