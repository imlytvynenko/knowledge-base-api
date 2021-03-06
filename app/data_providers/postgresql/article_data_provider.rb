module Postgresql
  class ArticleDataProvider
    include Postgresql::Utils::ConnectionProvider

    attr_accessor :options

    def initialize options = {}
      self.options = options
    end

    def get article_id
      query = Queries::Article.select(columns: ['*'], id: article_id)

      results = connection.execute(query) 

      to_article results[0].symbolize_keys
    end

    def create options
      query = Queries::Article.create({
        columns: [:title, :content, :tags, :created_at, :updated_at],
        title: options[:title],
        content: options[:content],
        tags: '{' + options[:tags] + '}',
        created_at: options[:created_at],
        updated_at: options[:updated_at]
      })

      connection.execute(query)
    end

    def search(options)
      query = Queries::Article.select({ 
        columns: [:id, :title, :content, :created_at], 
        offset: options[:offset],
        term: options[:term]
      })

      connection.execute(query)
    end

    def find_by(field, value)
      query = Queries::Article.select(columns: [:id, :title, :content, :created_at], tag: value)

      connection.execute(query)
    end

    private

    def to_articles results
      return [] if results.count.zero?

      results.map { |r| to_article(r.symbolize_keys) }
    end

    def to_article result
      ::Entities::Article.new({
        id: result[:id].to_s,
        title: result[:title],
        content: result[:content],
        created_at: result[:created_at].to_datetime,
        updated_at: result[:updated_at].to_datetime
      })
    end

    def limit
      options[:limit] || DEFAULT_BATCH_LIMIT
    end
  end
end

# provider = Postgresql::ArticleDataProvider.new
