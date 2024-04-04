# frozen_string_literal: true

class Mention < ApplicationRecord
  belongs_to :source, class_name: 'Report', inverse_of: :mentioned_sources
  belongs_to :destination, class_name: 'Report', inverse_of: :mentioning_destinations
end
