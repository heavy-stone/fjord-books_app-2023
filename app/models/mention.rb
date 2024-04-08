# frozen_string_literal: true

class Mention < ApplicationRecord
  belongs_to :source, class_name: 'Report', inverse_of: :source_mentions
  belongs_to :destination, class_name: 'Report', inverse_of: :destination_mentions

  validates :source, presence: true
  validates :destination, presence: true
end
