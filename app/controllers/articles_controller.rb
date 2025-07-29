class ArticlesController < ApplicationController
  before_action :set_article, only: [ :show, :update, :destroy ]

  # GET /articles
  def index
    articles = Article.all
    render json: articles
  end

  # GET /articles/:id
  def show
    render json: @article
  end

  # POST /articles
  def create
    # Rails.logger.debug "=== Incoming Params ==="
    # Rails.logger.debug params.to_unsafe_h

    article = Article.new(article_params)
    if article.save
      render json: article, status: :created
    else
      render json: article.errors, status: :unprocessable_entity
    end
  end

  # PUT/PATCH /articles/:id
  def update
    if @article.update(article_params)
      render json: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # DELETE /articles/:id
  def destroy
    @article.destroy
    head :no_content
  end

  private

  def set_article
    @article = Article.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Article not found" }, status: :not_found
  end

  def article_params
    params.require(:article).permit(:title, :content)
  end
end
