module Postgresql
  module Queries
    class User
      class << self
        SELECT_QUERY = 'SELECT %{columns} FROM users '

        def select(options)
          query = SELECT_QUERY
          query = decorate_query_by_id_search(query) if options[:id].present?
          query = decorate_query_by_username_search(query) if options[:username].present?
          query = decorate_query_by_email_search(query) if options[:email].present?

          query % options.
            slice(:id, :username, :email).
            with_defaults(columns: options[:columns].join(','))
        end

        def create(options)
          
        end

        private

        def decorate_query_by_id_search(query)
          query + "WHERE id = %{id}"
        end

        def decorate_query_by_username_search(query)
          query + "WHERE username = \'%{username}\'"
        end

        def decorate_query_by_email_search(query)
          query + "WHERE email = \'%{email}\'"
        end
      end
    end
  end
end
