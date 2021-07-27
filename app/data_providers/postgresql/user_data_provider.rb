module Postgresql
  class UserDataProvider
    include Postgresql::Utils::ConnectionProvider

    attr_accessor :options

    def initialize options = {}
      self.options = options
    end

    def insert(options)
      query = <<-SQL
        INSERT INTO users (username, email, password_digest, created_at, updated_at)
        VALUES (\'#{options[:username]}\', \'#{options[:email]}\', \'#{options[:password_digest]}\', \'#{options[:created_at]}\', \'#{options[:updated_at]}\');
      SQL

      connection.execute(query)
    end

    def get(user_id)
      query = Queries::User.select(columns: ['*'], id: user_id)

      results = connection.execute(query) 

      to_user results[0].symbolize_keys
    end

    def find_by_username(username)
      query = Queries::User.select(columns: ['*'], username: username)

      results = connection.execute(query) 

      to_user results[0].symbolize_keys
    end

    def find_by_email(email)
      query = Queries::User.select(columns: ['*'], email: email)

      results = connection.execute(query) 

      to_user results[0].symbolize_keys
    end

    private

    def to_user result
      ::Entities::User.new({
        id: result[:id].to_s,
        username: result[:username],
        email: result[:email],
        password_digest: result[:password_digest],
        created_at: result[:created_at].to_datetime,
        updated_at: result[:updated_at].to_datetime
      })
    end
  end
end

# provider = Postgresql::ArticleDataProvider.new
