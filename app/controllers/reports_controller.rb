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
    success = @report.transaction_save(report_params)
    if success
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      flash.now[:alert] = t('controllers.common.alert_create', name: Report.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    success = @report.transaction_save(report_params)
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
end
