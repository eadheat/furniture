module Api::V1
  class SessionsController < ApiController
    skip_before_action :authenticate_user_from_token!

    def create
      @user = User.find_by_email(params[:email])

      return invalid_login_attempt if @user.blank? || params[:password].blank?

      if @user.valid_password?(params[:password])

        render json: {
          status: "OK",
          auth_token: @user.access_token
        }
      else
        invalid_login_attempt
      end
    end

    private

    def invalid_login_attempt
      render json: {error: t('sessions.invalid_login_attempt')}, status: :unprocessable_entity
    end

  end
end