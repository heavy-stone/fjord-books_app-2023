# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :mentioned_sources, class_name: 'Mention',
                               foreign_key: :source_id,
                               inverse_of: :source,
                               dependent: :destroy
  has_many :mentioned_reports, through: :mentioned_sources, source: :destination
  has_many :mentioning_destinations, class_name: 'Mention',
                                     foreign_key: :destination_id,
                                     inverse_of: :destination,
                                     dependent: :destroy
  has_many :mentioning_reports, through: :mentioning_destinations, source: :source

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end
end
