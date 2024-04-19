# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :destination_mentions, class_name: 'Mention',
                                  foreign_key: :destination_id,
                                  inverse_of: :destination,
                                  dependent: :destroy
  has_many :mentioned_reports, -> { distinct }, through: :destination_mentions,
                                                source: :source
  has_many :source_mentions, class_name: 'Mention',
                             foreign_key: :source_id,
                             inverse_of: :source,
                             dependent: :destroy
  has_many :mentioning_reports, -> { distinct }, through: :source_mentions,
                                                 source: :destination

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def format_content
    safe_joined_content = ApplicationController.helpers.format_content(content)
    uri_reg = URI::DEFAULT_PARSER.make_regexp(%w[http https])
    safe_joined_content.gsub(uri_reg) { %(<a href='#{::Regexp.last_match(0)}' target='_blank'>#{::Regexp.last_match(0)}</a>) }
  end

  def transaction_save(report_params)
    transaction do
      success = destroy_all_mentions
      unless success
        logger.error I18n.t('controllers.common.alert_destroy_all', name: Mention.model_name.human)
        raise ActiveRecord::Rollback
      end
      assign_attributes(report_params)

      build_mentions(report_params[:content])
      success = save
      raise ActiveRecord::Rollback unless success

      success
    end
  end

  private

  def destroy_all_mentions
    mentions = source_mentions.destroy_all
    mentions.all?(&:destroyed?)
  end

  def build_mentions(content)
    report_show_path_ids = URI.extract(content, %w[http https]).uniq.map do |url|
      path = Rails.application.routes.recognize_path(url)
      is_report_show_path = path[:controller] == 'reports' && path[:action] == 'show'
      next if !is_report_show_path || path[:id].to_i == id

      path[:id]
    end

    valid_ids = Report.where(id: report_show_path_ids).pluck(:id)
    valid_ids.each do |id|
      source_mentions.build(destination_id: id)
    end
  end
end
