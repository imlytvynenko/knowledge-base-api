module UseCases
  module Articles
    class Create
      attr_accessor :data_provider, :context

      def initialize
        yield self
      end
      
      def perform(params)
        options = creation_options(params)

        data_provider.create(options)
      end

      private

      def creation_options(params)
        params.to_h.
          slice(:title, :content, :tags).
          with_defaults({
            created_at: Time.zone.now,
            updated_at: Time.zone.now,
            author_id: author.id
          })
      end

      def author
        @author ||= context[:author]
      end
    end
  end
end
