# frozen_string_literal: true

class Books::CommentsController < CommentsController
  private

  def set_commentable
    @comment.commentable = Book.find(params[:book_id])
  end

  def render_commentable_show
    @book = @comment.commentable
    render 'books/show', status: :unprocessable_entity
  end
end
