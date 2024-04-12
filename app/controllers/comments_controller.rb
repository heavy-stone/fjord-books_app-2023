# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)
    set_commentable
    if @comment.save
      redirect_to polymorphic_url(@comment.commentable), notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      flash.now[:alert] = t('controllers.common.alert_create', name: Comment.model_name.human)
      render_commentable_show
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    if @comment.destroy
      redirect_to polymorphic_url(@comment.commentable), notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
    else
      flash.now[:alert] = t('controllers.common.alert_destroy', name: Comment.model_name.human)
      render_commentable_show
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_commentable
    raise NotImplementedError, t('controllers.errors.not_implemented', name: "#{self.class}##{__method__}")
  end

  def render_commentable_show
    raise NotImplementedError, t('controllers.errors.not_implemented', name: "#{self.class}##{__method__}")
  end
end
