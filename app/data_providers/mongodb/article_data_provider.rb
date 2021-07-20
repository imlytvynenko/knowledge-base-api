module Mongodb
  class ArticleDataProvider
    include Mongodb::Utils::ConnectionProvider

    def find_by(field, value)
      results = documents.find(field => { '$regex' => value }).map { |document| document }
      to_articles results
    end

    private

    def documents
      connection[:articles]
    end

    def to_articles results
      return [] if results.count.zero?

      results.map { |r| to_article(r.symbolize_keys) }
    end

    def to_article result
      ::Entities::Article.new({
        id: result[:id].to_i,
        title: result[:title],
        content: result[:content],
        created_at: result[:created_at].to_datetime,
        updated_at: result[:updated_at].to_datetime
      })
    end
  end
end
