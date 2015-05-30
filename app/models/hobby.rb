class Hobby < ActiveRecord::Base
  belongs_to :category
  has_many :articles
  has_many :hobby_users
  has_many :users, :through => :hobby_users
end
