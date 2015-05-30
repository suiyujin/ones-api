class Article < ActiveRecord::Base
  belongs_to :user
  belongs_to :hobby

  # battle
  has_many :friendships_of_article1_id, :class_name => 'Battle', :foreign_key => 'article1_id', :dependent => :destroy
  has_many :friendships_of_article2_id, :class_name => 'Battle', :foreign_key => 'article2_id', :dependent => :destroy
  has_many :follows_of_article1_id, :through => :friendships_of_article1, :source => 'article1'
  has_many :follows_of_article2_id, :through => :friendships_of_article2, :source => 'article2'

  acts_as_commentable
  acts_as_votable
end
