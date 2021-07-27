class AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login

  def login
    use_case = UseCases::Users::Authenticate.new do |i|
      i.data_provider = data_provider
    end

    @user = use_case.perform(params)

    if @user.present?
      render json: use_case.auth_data, status: :ok
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
