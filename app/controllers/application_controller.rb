# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, unless: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name avatar])
  end

  def authenticate_user!
    return if user_signed_in?

    render json: { error: 'You need to sign in or sign up before continuing.' },
           status: :unauthorized
  end
end
