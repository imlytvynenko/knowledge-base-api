module UseCases
  module Users
    class Create
      attr_accessor :data_provider

      def initialize
        yield self
      end
      
      def perform(params)
        options = creation_options params

        data_provider.create(options)

        data_provider.find_by(:username, options[:username])
      end

      private

      def creation_options(params)
        {
          username: params[:username],
          email: params[:email],
          password_digest: BCrypt::Password.create(params[:password]),
          created_at: Time.zone.now,
          updated_at: Time.zone.now
        }
      end
    end
  end
end
