module Mongodb
  class UserDataProvider
    include Mongodb::Utils::ConnectionProvider
  
    attr_accessor :options

    def initialize options = {}
      self.options = options
    end

    def create options
      documents.insert_one(options)
    end

    def find_by(field, value)
      options = query_options(field, value)
      results = documents.find(options).map { |document| document }

      to_user results[0].symbolize_keys
    end

    private

    def documents
      connection[:users]
    end


    def to_user result
      ::Entities::User.new({
        id: result[:_id].to_s,
        username: result[:username],
        email: result[:email],
        password_digest: result[:password_digest],
        created_at: result[:created_at].to_datetime,
        updated_at: result[:updated_at].to_datetime
      })
    end

    def query_options(field, value) 
      return { :_id => BSON::ObjectId(value) } if field == :id
      { field => value }
    end
  end
end
