# frozen_string_literal: true

class ApplicationController < ActionController::Base
  if Rails.env.development?
    before_action do
      ActiveStorage::Current.url_options = { protocol: 'http', host: 'localhost', port: 3000 }
    end
  end

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    keys = %i[name postal_code address self_introduction icon]
    devise_parameter_sanitizer.permit(:sign_up, keys:)
    devise_parameter_sanitizer.permit(:account_update, keys:)
  end

  private

  def after_sign_in_path_for(_resource_or_scope)
    books_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  def signed_in_root_path(_resource_or_scope)
    user_path(current_user)
  end
end
