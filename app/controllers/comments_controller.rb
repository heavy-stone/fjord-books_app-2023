# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[destroy]

  def create
    @comment = Comment.new(comment_params.merge(user: current_user))
    if @comment.save
      redirect_to polymorphic_url(@comment.commentable), notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      @report = @comment.commentable
      flash.now[:alert] = t('controllers.common.alert_create', name: Comment.model_name.human)
      render 'reports/show', status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy

    redirect_to polymorphic_url(@comment.commentable), notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:commentable_type, :commentable_id, :content)
  end
end
