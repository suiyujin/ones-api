class Article < ActiveRecord::Base
  belongs_to :user
  belongs_to :hobby

  # battle
  has_many :battles_of_article1_id, :class_name => 'Battle', :foreign_key => 'article1_id', :dependent => :destroy
  has_many :battles_of_article2_id, :class_name => 'Battle', :foreign_key => 'article2_id', :dependent => :destroy
  has_many :buttles_of_article1, :through => :battles_of_article1_id, :source => 'article1'
  has_many :buttles_of_article2, :through => :battles_of_article2_id, :source => 'article2'

  acts_as_commentable
  acts_as_votable
end
