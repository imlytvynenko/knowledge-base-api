module UseCases
  module Articles
    class Search
      attr_accessor :data_provider

      def initialize
        yield self
      end
      
      def perform(options)
        return data_provider.find_by(:tag, options[:tag]) if  options[:tag].present? 
        
        data_provider.search(options)
      end
    end
  end
end
