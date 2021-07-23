module Postgresql
  module Queries
    class Article
      class << self
        DEFAULT_BATCH_LIMIT = 5
        SELECT_QUERY = 'SELECT %{columns} FROM articles '

        def select(options)
          query = SELECT_QUERY
          query = decorate_query_by_id_search(query) if options[:id].present?
          query = decorate_query_by_search(query) if options[:term].present?
          query = decorate_query_by_offset(query) if options[:offset].present?

          query % options.
            slice(:term, :offset, :id).
            with_defaults(columns: options[:columns].join(','))
        end

        private

        def decorate_query_by_id_search(query)
          query + "WHERE id = %{id}"
        end

        def decorate_query_by_search(query)
          query + "WHERE to_tsvector(articles.content) || to_tsvector(articles.title) @@ plainto_tsquery(\'%{term}\') "
        end

        def decorate_query_by_offset(query)
          query + "LIMIT #{DEFAULT_BATCH_LIMIT} OFFSET %{offset} "
        end
      end
    end
  end
end
