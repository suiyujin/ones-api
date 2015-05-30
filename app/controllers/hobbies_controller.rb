class HobbiesController < ApplicationController

  def getRanking

    @all_rank_array = Array.new
    @user = User.find(params[:my_id])
    @hobbies = @user.hobbies
    first_flag = true

    @hobbies.each do |hobby|

      @rank_array = Hash.new

      if first_flag == true then
        #総合ランキング
        @rank_array["hobby_id"] = 0
        @rank_array["hobby_name"] = "総合"
        @article = Article.all
        first_flag = false
      else
        #登録してるジャンルのランキング
        @rank_array["hobby_id"] = hobby.id
        @rank_array["hobby_name"] = hobby.name
        @article = Article.where(hobby_id: hobby.id)
      end

      @user_points = @article.order('sum_point desc').limit(100).group(:user_id).sum(:point)

      @all_user_array = Array.new
      @user_points.each{|key, value|
        @user_array = Hash.new
        @rank_user = User.find_by(id: key)
        @user_array["user_id"] = @rank_user.id
        @user_array["name"] = @rank_user.name
        @user_array["point"] = value
        @all_user_array.push(@user_array)
      }

      @rank_array["users"] = @all_user_array

      @all_rank_array.push(@rank_array)

    end

    @json_rank_array = Hash.new
    @json_rank_array["result"] = true
    @json_rank_array["data"] = @all_rank_array

    render :json => @json_rank_array

  end

end