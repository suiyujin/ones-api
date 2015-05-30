class UsersController < ApplicationController
  # GET /users/getUserInfo
  # params: target_id
  def getUserInfo
    login_user_id = params[:my_id].to_i
    login_user = User.find(login_user_id)

    target_user_id = params[:target_id].to_i
    target_user = User.find(target_user_id)

    # target_userをフォローしているか
    login_user_follow = login_user.follows_of_from_user.pluck(:id).include?(target_user_id)

    # target_userの記事一覧を取得
    articles_hash = make_articles_hash(target_user.articles, target_user)

    if articles_hash.blank?
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
          articles: articles_hash
        }
      }
    end

    render json: res
  end
end
