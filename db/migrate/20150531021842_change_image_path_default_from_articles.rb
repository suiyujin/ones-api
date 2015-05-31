class ChangeImagePathDefaultFromArticles < ActiveRecord::Migration
  def change
    change_column_default :articles, :image_path, 'http://otakku-no1.herokuapp.com/images/dummy_image.png'
  end
end
