class Battle < ActiveRecord::Base
  belongs_to :article1_id, :class_name => 'Article'
  belongs_to :article2_id, :class_name => 'Article'
end
