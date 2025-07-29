class BlogController < ApplicationController
  def index
    blog = Blog.all
    binding.pry # pauses here
    render json: blog
  end

  def create
    blog = Blog.new(blog_params)
    binding.pry  # pauses here
    if blog.save
      render json: blog, status: :created
    else
      render json: blog.errors, status: :unprocessable_entity
    end
  end

  private
  def blog_params
    params.permit(:blog_title, :blog_content, :blog_description)
  end
end
