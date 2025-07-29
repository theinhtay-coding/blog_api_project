class CreateBlogs < ActiveRecord::Migration[8.0]
  def change
    create_table :blogs do |t|
      t.string :blog_title
      t.string :blog_content
      t.string :blog_description

      t.timestamps
    end
  end
end
