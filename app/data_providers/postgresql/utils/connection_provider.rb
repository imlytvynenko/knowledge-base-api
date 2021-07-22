module Postgresql
  module Utils
    module ConnectionProvider
      DEFAULT_BATCH_LIMIT = 5

      def connection
        @connection ||= ActiveRecord::Base.establish_connection(
          adapter:  config[:adapter],
          host:     config[:host],
          database: config[:database],
          username: config[:username],
          password: config[:password]
        ).connection
      end

      def config
        @config ||= YAML.load_file('config/postgresql.yml').with_indifferent_access
      end
    end
  end
end
