class Api::V1::ArticlesController < ApplicationController

  before_action :set_article, only: [:show, :update, :destroy]

  def index
    @articles = Article.all

    render json: @articles, status: :ok
  end

  def show
    if @article.present?
      render json: @article, status: :ok
    else
      render json: @article.errors, status: :not_found
    end
  end

  def create
    source_params = params[:source]
    source = Source.find_or_create_by!(name: source_params[:name]) do |s|
      s.description = source_params[:description]
      s.url = source_params[:url]
      s.category = source_params[:category]
      s.language = source_params[:language]
      s.country = source_params[:country]
    end

    if source.persisted?
      @article = source.articles.build(article_params)

      if @article.new_record? && @article.save
        render json: @article, status: :created, location: @article
      else
          render json: { error: @article.errors }, status: :unprocessable_entity
      end
    end
  end

  def update
    if @article.update(article_params)
      render json: @article, status: :accepted
    else
      render json: { error: @article.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy

    render json: { error: "Article destroyed" }, status: :no_content
  end

  private

  def set_article
    @article = Article.find(params[:id])
  rescue => e
    Rails.logger.error "Error: #{e.message}"
    render json: { error: "Cannot found the article with id: #{params[:id]}" }, status: :bad_request
  end

  def article_params
    params.require(:article)
          .permit(:author,
                  :title,
                  :description,
                  :url,
                  :urlToImage,
                  :publishedAt,
                  :content
          )

  end
end
