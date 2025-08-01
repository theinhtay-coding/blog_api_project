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
      binding.pry # pauses here
      BlogMailer.blog_created(blog, current_user.email).deliver_now
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

  def export
    authorize Blog, :export?
    export_excel
  rescue => e
    render json: { error: "Export failed: #{e.message}" }, status: :internal_server_error
  end

  def bulk_export
    authorize Blog, :export?
    bulk_export_excel
  rescue => e
    render json: { error: "Bulk export failed: #{e.message}" }, status: :internal_server_error
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

  def export_excel
    require "axlsx"
    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(name: "Blog #{@blog.id}") do |sheet|
      sheet.add_row [ "Blog Details" ], style: workbook.styles.add_style(b: true, sz: 16)
      sheet.add_row []
      sheet.add_row [ "ID", @blog.id ]
      sheet.add_row [ "Title", @blog.blog_title ]
      sheet.add_row [ "Content", @blog.blog_content ]
      sheet.add_row [ "Description", @blog.blog_description ]
      sheet.add_row [ "Created At", @blog.created_at ]
      sheet.add_row [ "Updated At", @blog.updated_at ]
      sheet.column_widths 15, 50
    end

    filename = "blog_#{@blog.id}_#{Date.current.strftime('%Y%m%d')}.xlsx"
    send_data package.to_stream.read,
              filename: filename,
              type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
              disposition: "attachment"
  end

  def bulk_export_excel
    require "axlsx"
    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(name: "Blogs") do |sheet|
      header_style = workbook.styles.add_style(b: true, bg_color: "CCCCCC")
      sheet.add_row [ "ID", "Title", "Content", "Description", "Created At", "Updated At" ], style: header_style
      Blog.all.each do |blog|
        sheet.add_row [
          blog.id,
          blog.blog_title,
          blog.blog_content,
          blog.blog_description,
          blog.created_at,
          blog.updated_at
        ]
      end
      sheet.column_widths 8, 30, 40, 30, 20, 20
    end

    filename = "blogs_export_#{Date.current.strftime('%Y%m%d')}.xlsx"
    send_data package.to_stream.read,
              filename: filename,
              type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
              disposition: "attachment"
  end
end
