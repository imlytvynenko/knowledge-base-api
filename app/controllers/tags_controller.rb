class TagsController < ApplicationController
  before_action :authorize_request, only: :create

  def index
    use_case = ::UseCases::Articles::Tags::Get.new do |i|
      i.data_provider = data_provider
    end

    tags = use_case.perform

    render json: { tags: tags }
  end

  private

  def data_provider
    @data_provider ||= ::DataProviderFactory.build(:article)
  end
end
