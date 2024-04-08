# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)

    @report.build_mentions(report_params[:content])
    if @report.save
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      flash.now[:alert] = t('controllers.common.alert_create', name: Report.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    success = true
    ActiveRecord::Base.transaction do
      success &= destroy_all_mentions
      unless success
        logger.error t('controllers.common.alert_destroy_all', name: Mention.model_name.human)
        raise ActiveRecord::Rollback
      end

      @report.build_mentions(report_params[:content])
      success &= @report.update(report_params)
      unless success
        logger.error t('controllers.common.alert_update', name: Report.model_name.human)
        raise ActiveRecord::Rollback
      end
    end

    if success
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      flash.now[:alert] = t('controllers.common.alert_update', name: Report.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @report.destroy
      redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
    else
      flash.now[:alert] = t('controllers.common.alert_destroy', name: Report.model_name.human)
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end

  def destroy_all_mentions
    mentions = @report.source_mentions.destroy_all
    mentions.all?(&:destroyed?)
  end
end
