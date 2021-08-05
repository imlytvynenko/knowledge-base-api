module Mongodb
  class TagDataProvider
    include Mongodb::Utils::ConnectionProvider
  
    attr_accessor :options

    def initialize options = {}
      self.options = options
    end

    def all
      ['general']
    end
  end
end
