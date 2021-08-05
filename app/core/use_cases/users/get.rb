module UseCases
  module Users
    class Get
      attr_accessor :data_provider

      def initialize
        yield self
      end
      
      def perform(id)
        data_provider.find_by(id: id)
      end
    end
  end
end
