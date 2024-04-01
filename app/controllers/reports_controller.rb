# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_current_user_report, only: %i[edit update destroy]

  def index
    @reports = Report.order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.preload(comments: :user).find(params[:id])
  end

  def new
    @report = Report.new
  end

  def edit; end

  def create
    @report = Report.new(report_params.merge(user: current_user))

    if @report.save
      redirect_to report_url(@report), notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      flash.now[:alert] = t('controllers.common.alert_create', name: Report.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @report.update(report_params)
      redirect_to report_url(@report), notice: t('controllers.common.notice_update', name: Report.model_name.human)
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

  def set_current_user_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:user_id, :title, :content)
  end
end
