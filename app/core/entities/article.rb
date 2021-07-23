module Entities
  class Article < Dry::Struct
    attribute :id, Types::String
    attribute :title, Types::String
    attribute :content, Types::String
    # attribute? :tags, Types::Array
    attribute :created_at, Types::DateTime
    attribute :updated_at, Types::DateTime
  end
end
