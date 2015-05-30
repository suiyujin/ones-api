class AddBpToUsersArticles < ActiveRecord::Migration
  def change
    add_column :articles, :buttle_points, :float, :default => 0.0
    add_column :users, :buttle_points, :float, :default => 0.0
  end
end
