# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    user
    title { '初日報' }
    content { '初めての日報です。' }
  end
end
