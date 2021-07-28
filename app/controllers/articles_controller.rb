class ArticlesController < ApplicationController
  # before_action :authorize_request, only: :create

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

  def create
    use_case = ::UseCases::Articles::Create.new do |i|
      i.data_provider = data_provider
    end

    article = use_case.perform(articles_params)

    if article.present?
      render json: article, status: :created
    else
      render json: { errors: 'Article not found' }, status: :unprocessable_entity
    end
  end

  private

  def articles_params
    params.permit(:title, :content)
  end

  def data_provider
    @data_provider ||= ::DataProviderFactory.build(:article)
  end
end
