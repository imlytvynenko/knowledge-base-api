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
        set_password_status params[:password]

        @valid_password ? @user : nil
      end

      def auth_data
        { token: token, exp: exp, username: @user.username }
      end

      private

      def set_user(email)
        @user = data_provider.`find_by`(:email, email)
      end

      def set_password
        return if @user.blank?

        @password = BCrypt::Password.new(@user.password_digest)
      end

      def set_password_status(password)
        @valid_password = @password == password
      end

      def password_correct?(password)
        @valid_password = @password == password
      end

      def token
        return unless @valid_password

        JsonWebToken.encode(user_id: @user.id)
      end

      def exp
        @exp ||= (Time.now + 24.hours.to_i).strftime("%m-%d-%Y %H:%M")
      end
    end
  end
end
