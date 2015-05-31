class HobbiesController < ApplicationController
  def getRanking
    @all_rank_array = Array.new
    @user = User.find(params[:my_id])
    hobbies = @user.hobbies

    #総合ランキング
    @rank_array = Hash.new
    @rank_array["hobby_id"] = 0
    @rank_array["hobby_name"] = "総合"
    articles = Article.all

    getRankSub(articles)

    hobbies.each do |hobby|
      @rank_array = Hash.new

      #登録してるジャンルのランキング
      @rank_array["hobby_id"] = hobby.id
      @rank_array["hobby_name"] = hobby.name
      articles_by_hobby = Article.where(hobby_id: hobby.id)

      getRankSub(articles_by_hobby)
    end

    json_rank_array = Hash.new
    json_rank_array["result"] = true
    json_rank_array["data"] = @all_rank_array

    render :json => json_rank_array
  end

  private
  def getRankSub(articles)
    user_points = articles.group(:user_id).sum(:point)

    all_user_array = Array.new
    user_points.each do |key, value|
      user_array = Hash.new
      rank_user = User.find_by(id: key)
      user_array["user_id"] = rank_user.id
      user_array["name"] = rank_user.name
      point = value / rank_user.articles.count
      user_array["point"] = point
      user_array["profile_image_url"] = rank_user.profile_image_path
      all_user_array.push(user_array)
    end

    all_user_array = all_user_array.sort { |a,b| a['point'] <=> b['point'] }.reverse
    @rank_array["users"] = all_user_array

    @all_rank_array.push(@rank_array)
  end
end
