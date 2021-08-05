class DataProviderFactory
  DRIVER = :postgresql

  def self.build(name)
    # TODO: handle exception when name is incorrect
    self.factories[DRIVER][name].new
  end

  private

  def self.factories
    {
      postgresql: {
        user: Postgresql::UserDataProvider,
        article: Postgresql::ArticleDataProvider,
        tag: Postgresql::TagDataProvider
      },
      mongodb: {
        user: Mongodb::UserDataProvider,
        article: Mongodb::ArticleDataProvider,
        tag: Mongodb::TagDataProvider
      } 
    }
  end
end
