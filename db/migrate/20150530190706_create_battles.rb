class CreateBattles < ActiveRecord::Migration
  def change
    create_table :battles do |t|
      t.integer  :article1_id, null: false
      t.integer  :article2_id, null: false
      t.integer  :vote1_num, default: 0
      t.integer  :vote2_num, default: 0
      t.timestamps null: false
    end
  end
end
