require 'mongo'

module Mongodb
  module Utils
    module ConnectionProvider
      MAX_SELECTION_COUNT = 5

      def connection
        @connection = Mongo::Client.new([ '127.0.0.1:27017' ], database: 'knowledge_base_portal')
      end

      def config
        @config ||= YAML.load_file('config/mongodb.yml').with_indifferent_access
      end
    end
  end
end

# p = Mongodb::ArticleDataProvider.new
