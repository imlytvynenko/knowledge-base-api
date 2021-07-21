module UseCases
  module Articles
    class Get
      attr_accessor :data_provider

      def initialize
        yield self
      end
      
      def perform(article_id:)
        data_provider.fetch_details(article_id)
      end
    end
  end
end
