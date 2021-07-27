module UseCases
  module Users
    class Get
      attr_accessor :data_provider

      def initialize
        yield self
      end
      
      def perform(params)
        data_provider.find_by_email(options[:email])
      end
    end
  end
end
