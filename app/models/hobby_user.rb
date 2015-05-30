class HobbyUser < ActiveRecord::Base
  belongs_to :hobby
  belongs_to :user
end
