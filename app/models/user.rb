class User < ActiveRecord::Base
  has_many :articles, :hobby_users
  has_many :hobbies, :through => :hobby_users
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
