module Postgresql
  class TagDataProvider
    include Postgresql::Utils::ConnectionProvider

    attr_accessor :options

    def initialize options = {}
      self.options = options
    end

    def all
      query = 'SELECT DISTINCT unnest(articles.tags) FROM articles'
      
      @all ||= connection.execute(query).map { |e| e['unnest'] }
    end
  end
end
