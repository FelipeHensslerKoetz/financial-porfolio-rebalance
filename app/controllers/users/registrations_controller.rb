# frozen_string_literal: true

# This controller is used to override the default Devise controller for registrations.
class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix
  respond_to :json
  skip_before_action :authenticate_user!

  private

  def respond_with(current_user, _opts = {})
    if resource.persisted?
      render json: {
        status: { code: 200, message: 'Signed up successfully.' },
        data: current_user
      }
    else
      render json: {
        status: { message: "User couldn't be created successfully. #{current_user.errors.full_messages.to_sentence}" }
      }, status: :unprocessable_entity
    end
  end
end
