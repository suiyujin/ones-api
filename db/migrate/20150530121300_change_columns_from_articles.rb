class ChangeColumnsFromArticles < ActiveRecord::Migration
  def change
    change_column_default( :articles,  :point, 0 )
    change_column_default( :articles,  :view_count, 0 )
  end
end
