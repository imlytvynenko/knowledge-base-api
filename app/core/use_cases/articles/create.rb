module UseCases
  module Articles
    class Create
      attr_accessor :data_provider

      def initialize
        yield self
      end
      
      def perform(params)
        options = creation_options(params)
        
        data_provider.insert(options)
      end

      private

      def creation_options(params)
        params.
          slice(:title, :content).
          with_defaults({
            created_at: Time.zone.now,
            updated_at: Time.zone.now
          })
      end
    end
  end
end
