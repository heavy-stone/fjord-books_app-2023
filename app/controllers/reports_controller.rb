# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @reports = current_user_reports.page(params[:page])
  end

  def show; end

  def new
    @report = Report.new
  end

  def edit; end

  def create
    @report = Report.new(report_params.merge(user_id: current_user.id))

    if @report.save
      redirect_to report_url(@report), notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @report.update(report_params)
      redirect_to report_url(@report), notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity

    end
  end

  def destroy
    @report.destroy

    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def current_user_reports
    Report.where(user_id: current_user.id).order(id: :desc)
  end

  def set_report
    @report = current_user_reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:user_id, :title, :content)
  end

  def record_not_found
    redirect_to reports_url, alert: t('activerecord.errors.messages.not_found', record: Report.model_name.human)
  end
end
