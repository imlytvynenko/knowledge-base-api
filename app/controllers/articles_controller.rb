class ArticlesController < ApplicationController
  def index
    use_case = ::UseCases::Articles::Search.new do |i|
      i.data_provider = data_provider
    end

    articles = use_case.perform(params.slice(:offset, :limit, :term))

    render json: { articles: articles }
  end

  def show
    use_case = ::UseCases::Articles::Get.new do |i|
      i.data_provider = data_provider
    end

    article = use_case.perform(article_id: params[:id])

    render json: { article: article }
  end

  private

  def data_provider
    # @data_provider ||= Mongodb::ArticleDataProvider.new
    @data_provider ||= Postgresql::ArticleDataProvider.new
  end
end
