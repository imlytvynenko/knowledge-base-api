module UseCases
  module Articles
    class Search
      attr_accessor :data_provider

      def initialize
        yield self
      end
      
      def perform(options)
        data_provider.find_by('title', options[:term])
      end
    end
  end
end
