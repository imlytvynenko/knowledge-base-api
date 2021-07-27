module UseCases
  module Users
    class Authenticate
      attr_accessor :data_provider

      def initialize
        yield self
      end
      
      def perform(params)
        set_user params[:email]
        set_password

        password_correct?(params[:password]) ? @user : nil
      end

      private

      def set_user(email)
        @user = data_provider.find_by_email(email)
      end

      def set_password
        return if @user.blank?

        @password = BCrypt::Password.new(@user.password_digest)
      end

      def password_correct?(password)
        @user.present? && @password == password
      end
    end
  end
end
