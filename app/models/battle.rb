class Battle < ActiveRecord::Base
  belongs_to :article1, :class_name => 'Article'
  belongs_to :article2, :class_name => 'Article'
end