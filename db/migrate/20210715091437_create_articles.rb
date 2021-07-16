class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.string :tags, array: true, default: []

      t.timestamps
    end
  end
end
