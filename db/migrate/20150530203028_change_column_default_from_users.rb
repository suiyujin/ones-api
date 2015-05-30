class ChangeColumnDefaultFromUsers < ActiveRecord::Migration
  def change
    change_column_default :users, :profile_image_path, 'http://otakku-no1.herokuapp.com/images/dummy_user.jpg'
  end
end
