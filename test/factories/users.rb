# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { "person#{_1}@example.com" }
    sequence(:password) { "password#{_1}" }
  end
end
