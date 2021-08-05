class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  BARCH_LIMIT = 5

  def not_found
    render json: { error: 'not_found' }
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header

    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = fetch_user(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  private
  
  def fetch_user(id)
    use_case = ::UseCases::Users::Get.new do |i|
      i.data_provider = ::DataProviderFactory.build(:user)
    end

    use_case.perform(id)
  end
end
