class BlogController < ApplicationController
  before_action :set_blog, only: [ :show, :update, :destroy ]

  def index
    authorize Blog
    blog = Blog.all
    binding.pry # pauses here
    render json: blog
  end

  def show
    render json: @blog
  end

  def create
    authorize Blog, :create?
    blog = Blog.new(blog_params)
    binding.pry  # pauses here
    if blog.save
      render json: blog, status: :created
    else
      render json: blog.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize Blog, :update?
    if @blog.update(blog_params)
      render json: @blog
    else
      render json: @blog.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize Blog
    @blog.destroy
    head :no_content
  end

  private
  def blog_params
    params.permit(:blog_title, :blog_content, :blog_description)
  end

  def set_blog
    @blog = Blog.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Blog not found" }, status: :not_found
  end
end
