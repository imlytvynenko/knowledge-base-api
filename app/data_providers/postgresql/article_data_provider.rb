module Postgresql
  class ArticleDataProvider
    include Postgresql::Utils::ConnectionProvider

    attr_accessor :options

    def initialize options = {}
      self.options = options
    end

    def full_text_search(options)
      connection.execute(
        load_collection_query(options[:term], options[:offset])
      )
    end

    def load_collection_query(term, offset)
      query = "SELECT * FROM articles "
      query = query + search_condition_query(term) if term.present?
      query = query + batch_settings_query(offset) if offset.present?
      query
    end
    
    def batch_settings_query(offset)
      "LIMIT #{limit} OFFSET #{offset || 0} "
    end

    def search_condition_query(term)
      "WHERE to_tsvector(articles.content) || to_tsvector(articles.title) @@ plainto_tsquery(\'#{term.to_s}\') "
    end

    def fetch_previews(field, term)
      results = connection.execute("SELECT * from articles WHERE #{field} ILIKE '%#{term}%'")

      to_articles results
    end

    def fetch_details article_id
      results = connection.execute("SELECT * from articles WHERE id = #{article_id}")

      to_article results[0].symbolize_keys
    end

    def insert data
      connection.execute()
    end

    private

    def to_articles results
      return [] if results.count.zero?

      results.map { |r| to_article(r.symbolize_keys) }
    end

    def to_article result
      ::Entities::Article.new({
        id: result[:id],
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
