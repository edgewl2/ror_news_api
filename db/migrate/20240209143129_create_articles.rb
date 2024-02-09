class CreateArticles < ActiveRecord::Migration[7.1]
  def change
    create_table :articles do |t|
      t.string :author
      t.string :title
      t.string :description
      t.string :url
      t.string :urlToImage
      t.datetime :publishedAt
      t.text :content
      t.references :source, null: false, foreign_key: true

      t.timestamps
    end
  end
end
