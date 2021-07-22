module UseCases
  module Articles
    class Search
      attr_accessor :data_provider

      def initialize
        yield self
      end
      
      def perform(options)
        data_provider.full_text_search(options)
      end
    end
  end
end
