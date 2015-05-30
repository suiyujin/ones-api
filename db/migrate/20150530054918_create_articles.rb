class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :image_path
      t.text :contents
      t.integer :view_count
      t.float :point
      t.datetime :published_at
      t.references :user, index: true, foreign_key: true
      t.references :hobby, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
