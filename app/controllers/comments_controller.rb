# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)
    @comment.commentable = Book.find(params[:book_id]) if params[:book_id].present?
    @comment.commentable = Report.find(params[:report_id]) if params[:report_id].present?
    if @comment.save
      redirect_to polymorphic_url(@comment.commentable), notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      render_commentable_show
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    if @comment.destroy
      redirect_to polymorphic_url(@comment.commentable), notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
    else
      render_commentable_show
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def render_commentable_show
    flash.now[:alert] = t("controllers.common.alert_#{action_name}", name: Comment.model_name.human)
    singular_commentable_name = @comment.commentable_type.downcase
    instance_variable_set("@#{singular_commentable_name}", @comment.commentable)
    render "#{singular_commentable_name.pluralize}/show", status: :unprocessable_entity
  end
end
