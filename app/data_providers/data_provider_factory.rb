class DataProviderFactory
  DRIVER = :mongodb

  def self.build(name)
    # TODO: handle exception when name is incorrect
    self.factories[DRIVER][name].new
  end

  private

  def self.factories
    {
      postgresql: {
        user: Postgresql::UserDataProvider,
        article: Postgresql::ArticleDataProvider
      },
      mongodb: {
        article: Mongodb::ArticleDataProvider
      } 
    }
  end
end
