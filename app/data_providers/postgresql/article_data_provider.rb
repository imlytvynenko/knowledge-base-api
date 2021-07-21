module Postgresql
  class ArticleDataProvider
    include Postgresql::Utils::ConnectionProvider

    def full_text_search(term)
      results = connection.execute <<-SQL
        SELECT * 
        FROM articles 
        WHERE to_tsvector(articles.content) || to_tsvector(articles.title) @@ plainto_tsquery(\'#{term.to_s}\');
      SQL
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
  end
end

# provider = Postgresql::ArticleDataProvider.new
