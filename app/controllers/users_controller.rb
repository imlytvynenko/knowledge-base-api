class UsersController < ApplicationController
  before_action :authorize_request, except: :create

  def create
    use_case = ::UseCases::Users::Create.new do |i|
      i.data_provider = data_provider
    end

    user = use_case.perform(user_params)

    if user.present?
      render json: user, status: :created
    else
      render json: { errors: 'User not found' }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:username, :email, :password, :password_confirmation)
  end

  def data_provider
    @data_provider ||= ::DataProviderFactory.build(:user)
  end
end
