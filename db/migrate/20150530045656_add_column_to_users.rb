class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string, null: false, default: '名称未設定'
    add_column :users, :profile_image_path, :string, default: 'image/dummy_user.jpg'
    add_column :users, :profile, :string
  end
end
