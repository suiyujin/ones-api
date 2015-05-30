class UsersController < ApplicationController
  # GET /users/getUserInfo
  # params: target_id
  def getUserInfo
    # とりあえず決め打ち
    login_user_id = params[:my_id].to_i
    login_user = User.find(login_user_id)

    target_user_id = params[:target_id].to_i
    target_user = User.find(target_user_id)

    # target_userをフォローしているか
    login_user_follow = login_user.follows_of_from_user.pluck(:id).include?(target_user_id)

    # target_userの記事一覧を取得
    articles = target_user.articles

    articles = articles.map do |article|
      article_hash = article.attributes
      article_hash['published_at'] = article_hash['published_at'].strftime("%Y/%m/%d")
      vote_type = target_user.voted_as_when_voted_for(article)
      if vote_type.nil?
        article_hash['vote_type'] = 2
      elsif vote_type
        article_hash['vote_type'] = 0
      else
        article_hash['vote_type'] = 1
      end

      article_hash['good_count'] = article.get_likes.size
      article_hash['bad_count'] = article.get_dislikes.size

      article_hash['comments'] = article.comments.map do |comment|
        {
          name: comment.user.name,
          text: comment.comment
        }
      end

      article_hash['user_name'] = article.user.name
      article_hash['hobby_name'] = article.hobby.name

      article_hash
    end

    if articles.blank?
      res = {
        result: false,
        data: nil
      }
    else
      res = {
        result: true,
        data: {
          user_id: target_user_id,
          name: target_user.name,
          follow: login_user_follow,
          articles: articles
        }
      }
    end

    render json: res
  end
end
