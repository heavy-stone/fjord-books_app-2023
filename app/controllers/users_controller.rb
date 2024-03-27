# frozen_string_literal: true

class UsersController < ApplicationController
  include ActiveStorage::SetCurrent

  def index
    @users = User.order(:id).page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end
end
