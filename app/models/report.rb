# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user

  validates :title, :content, presence: true
end
