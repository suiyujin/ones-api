class Hobby < ActiveRecord::Base
  belongs_to :category
  has_many :articles
end
