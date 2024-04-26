# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    sequence(:title) { "本のタイトル#{_1}" }
  end
end
