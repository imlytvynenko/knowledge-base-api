module UseCases
  module Articles
    module Tags
      class Get
        attr_accessor :data_provider
  
        def initialize
          yield self
        end
        
        def perform
          data_provider.all
        end
      end
    end
  end
end
