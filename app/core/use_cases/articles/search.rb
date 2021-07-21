module UseCases
  module Articles
    class Search
      attr_accessor :data_provider

      def initialize
        yield self
      end
      
      def perform(options)
        return [] if options[:term].blank?

        data_provider.full_text_search(options[:term])
      end
    end
  end
end
