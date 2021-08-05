module Mongodb
  class ArticleDataProvider
    include Mongodb::Utils::ConnectionProvider
  
    attr_accessor :options

    def initialize options = {}
      self.options = options
    end

    def get article_id
      results = documents.find(:_id => BSON::ObjectId(article_id)).map { |document| document }

      to_article results[0].symbolize_keys
    end

    def create(options)
      results = documents.insert_one(options)

      get(results.inserted_id.to_s)
    end

    def search(options)
      results = data_scope(options[:term]).
        sort('created_at': 1).
        skip(options[:offset].to_i).
        limit(limit).
        map { |document| document }
      
      to_articles results
    end

    def find_by(field, value)
      # temporary disable
      documents.find.map { |document| document }
    end

    private
    
    def data_scope(searchTerm)
      return documents.find if searchTerm.blank?

      documents.find('$text': { '$search': searchTerm, '$caseSensitive': false })
    end

    def documents
      connection[:articles]
    end

    def to_articles results
      return [] if results.count.zero?

      results.map { |r| to_article(r.symbolize_keys) }
    end

    def to_article result
      ::Entities::Article.new({
        id: result[:_id].to_s,
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
