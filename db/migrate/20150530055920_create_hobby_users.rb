class CreateHobbyUsers < ActiveRecord::Migration
  def change
    create_table :hobby_users do |t|
      t.references :hobby, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.integer :ranking, default: 0

      t.timestamps null: false
    end
  end
end
