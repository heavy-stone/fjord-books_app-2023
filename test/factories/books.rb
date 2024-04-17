# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    title { 'Ruby on Rails チュートリアル' }
    memo { '難しいですがためになります！' }
    author { 'Michael Hartl' }
    picture { Rack::Test::UploadedFile.new(Rails.root.join('test/fixtures/files/images/rails_tutorial1.jpg'), 'image/jpg') }
  end
end
