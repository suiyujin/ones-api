class HobbiesController < ApplicationController

  def getRanking

    @all_rank_array = Array.new
    @user = User.find(params[:my_id])
    @hobbies = @user.hobbies

    #総合ランキング
    @rank_array = Hash.new
    @rank_array["hobby_id"] = 0
    @rank_array["hobby_name"] = "総合"
    @article = Article.all

    getRankSub(@article)

    @hobbies.each do |hobby|

      @rank_array = Hash.new

      #登録してるジャンルのランキング
      @rank_array["hobby_id"] = hobby.id
      @rank_array["hobby_name"] = hobby.name
      @article = Article.where(hobby_id: hobby.id)

      getRankSub(@article)

    end

    @json_rank_array = Hash.new
    @json_rank_array["result"] = true
    @json_rank_array["data"] = @all_rank_array

    render :json => @json_rank_array

  end

  private
  def getRankSub(article)
    @user_points = article.group(:user_id).sum(:point)

    @all_user_array = Array.new
    @user_points.each{|key, value|
      @user_array = Hash.new
      @rank_user = User.find_by(id: key)
      @user_array["user_id"] = @rank_user.id
      @user_array["name"] = @rank_user.name
      @point = value / @rank_user.articles.count
      @user_array["point"] = @point
      @all_user_array.push(@user_array)
    }

    @all_user_array = @all_user_array.sort{|a,b| a[:point] <=> b[:point]}.reverse
    @rank_array["users"] = @all_user_array

    @all_rank_array.push(@rank_array)
  end

end