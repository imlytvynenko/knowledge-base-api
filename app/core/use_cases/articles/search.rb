module UseCases
  module Articles
    class Search
      attr_accessor :data_provider

      def initialize
        yield self
      end
      
      def perform(options)
        options[:tag].present? ? data_provider.fetch_by_tag(options) : data_provider.full_text_search(options)
      end
    end
  end
end
