class BlogMailer < ApplicationMailer
  default from: "theinhtay.dev@gmail.com"

  def blog_created(blog, user_email)
    @blog = blog
    mail(to: user_email, subject: "New Blog created: #{@blog.blog_title}")
  end
end
