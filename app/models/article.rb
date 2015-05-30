class Article < ActiveRecord::Base
  belongs_to :user
  belongs_to :hobby

  acts_as_commentable
  acts_as_votable
end
