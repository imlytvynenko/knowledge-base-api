module Postgresql
  class ArticleDataProvider
    include Postgresql::Utils::ConnectionProvider
    
    def all(options = { limit: MAX_SELECTION_COUNT })
      results = connection.execute('SELECT * from articles LIMIT %s' % options[:limit])
    
      to_articles results
    end

    def find_by(field, value)
      results = connection.execute(
        ActiveRecord::Base.sanitize_sql_array([
          Arel.sql(
            <<-SQL
              SELECT * from articles
              WHERE #{field} ILIKE :value
            SQL
          ), { value: ('%' + value.downcase + '%') }
        ])
      )

      to_articles results
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
