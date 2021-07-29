module Mongodb
  class UserDataProvider
    include Mongodb::Utils::ConnectionProvider
  
    attr_accessor :options

    def initialize options = {}
      self.options = options
    end

    def insert(options)
      documents.insert_one(options)
    end

    def find_by_id(id)
      results = documents.find(:_id => BSON::ObjectId(id)).map { |document| document }

      to_user results[0].symbolize_keys
    end

    def find_by_username(username)
      results = documents.find(username: username).map { |document| document }

      to_user results[0].symbolize_keys
    end

    def find_by_email(email)
      results = documents.find(email: email).map { |document| document }

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
  end
end
