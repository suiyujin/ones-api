class ChangeImagePathFromArticles < ActiveRecord::Migration
  def change
    change_column :articles, :image_path, :string, null: false, default: 'http://otakku-no1.herokuapp.com/images/dummy_image.png'
  end
end
