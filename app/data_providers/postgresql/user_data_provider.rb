module Postgresql
  class UserDataProvider
    include Postgresql::Utils::ConnectionProvider

    attr_accessor :options

    def initialize options = {}
      self.options = options
    end

    def create(options)
      query = Queries::Article.create({
        columns: [:title, :content, :created_at, :updated_at, :author_id],
        username: options[:title],
        email: options[:content],
        password_digest: options[:password_digest],
        created_at: options[:created_at],
        updated_at: options[:updated_at],
        author_id: options[:author_id],
      })

      connection.execute(query)
    end

    def find_by(field, value)
      query = Queries::User.select(:columns => ['*'], field => value)

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
