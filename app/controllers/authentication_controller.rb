class AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login

  def login
    use_case = UseCases::Users::Authenticate.new do |i|
      i.data_provider = data_provider
    end

    @user = use_case.perform(params)

    if @user.present?
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                     username: @user.username }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end

  def data_provider
    @data_provider ||= ::DataProviderFactory.build(:user)
  end
end
