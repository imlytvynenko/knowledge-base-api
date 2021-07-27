module Entities
  class User < Dry::Struct
    attribute :id, Types::String
    attribute :username, Types::String
    attribute :email, Types::String
    attribute :password_digest, Types::String
    attribute :created_at, Types::DateTime
    attribute :updated_at, Types::DateTime
  end
end
