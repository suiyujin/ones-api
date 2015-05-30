class AddPhotoUrlToHobbies < ActiveRecord::Migration
  def change
    add_column :hobbies, :photo_url, :string
  end
end
