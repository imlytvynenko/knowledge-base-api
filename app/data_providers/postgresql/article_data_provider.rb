module Postgresql
  class ArticleDataProvider
    include Postgresql::Utils::ConnectionProvider

    attr_accessor :options

    def initialize options = {}
      self.options = options
    end

    def all_tags
      query = 'SELECT DISTINCT unnest(articles.tags) FROM articles'

      connection.execute(query).map { |e| e['unnest'] }
    end

    def full_text_search(options)
      query = Queries::Article.select({ 
        columns: [:id, :title, :content, :created_at], 
        offset: options[:offset],
        term: options[:term]
      })

      connection.execute(query)
    end

    def fetch_by_tag(options)
      query = Queries::Article.select({ 
        columns: [:id, :title, :content, :created_at],
        tag: options[:tag]
      })

      connection.execute(query)
    end

    def fetch_details article_id
      query = Queries::Article.select(columns: ['*'], id: article_id)

      results = connection.execute(query) 

      to_article results[0].symbolize_keys
    end

    def insert(options)
      query = Queries::Article.insert({
        columns: [:title, :content, :created_at, :updated_at],
        title: options[:title],
        content: options[:content],
        created_at: options[:created_at],
        updated_at: options[:updated_at]
      })

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
