class UsersController < ApplicationController
  protect_from_forgery except: [ :follow, :unfollow]

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
          profile_image: target_user.profile_image_path,
          articles: articles_hash
        }
      }
    end

    render json: res
  end

  # GET /users/getHobbies
  # params: my_id
  def getHobbies
    login_user_id = params[:my_id]
    login_user = User.find(login_user_id)

    hobbies = login_user.hobbies

    hobbies_hash = hobbies.map do |hobby|
      hobby_hash = hobby.attributes
      hobby_hash['category_name'] = hobby.category.name
      hobby_hash['photo_url'] = hobby.photo_url
      hobby_hash
    end

    if hobbies_hash.blank?
      res = {
        result: false,
        data: nil
      }
    else
      res = {
        result: true,
        data: {
          user_id: login_user_id,
          name: login_user.name,
          hobbies: hobbies_hash
        }
      }
    end

    render json: res
  end

  def getTimeLine
    login_user_id = params[:my_id]
    login_user = User.find(login_user_id)

    limit_num = 20

    follow_users = login_user.follows_of_from_user

    follow_users_articles = Array.new
    follow_users.each do |follow_user|
      follow_users_articles << make_articles_hash(follow_user.articles, follow_user)
    end
    follow_users_articles.flatten!

    articles_new = follow_users_articles.sort do |a, b|
      a['created_at'] <=> b['created_at']
    end.reverse.shift(limit_num)

    follow_users_articles_hot = follow_users_articles.select do |follow_users_article|
      follow_users_article['created_at'] >= 1.weeks.ago
    end
    articles_hot = follow_users_articles_hot.sort do |a, b|
      a['point'] <=> b['point']
    end.reverse.shift(limit_num)

    articles_legend = follow_users_articles.sort do |a, b|
      a['point'] <=> b['point']
    end.reverse.shift(limit_num)

    if follow_users_articles.blank?
      res = {
        result: false,
        data: nil
      }
    else
      res = {
        result: true,
        data: [
          {
            segment_type: 'new',
            articles: articles_new
          },
          {
            segment_type: 'hot',
            articles: articles_hot
          },
          {
            segment_type: 'legend',
            articles: articles_legend
          }
        ]
      }
    end

    render json: res
  end

  def follow
    Follow.find_or_create_by(from_user_id: params[:my_id],to_user_id: params[:target_id])
    render nothing: true
  end

  def unfollow
    unfollow_data = Follow.find_by(from_user_id: params[:my_id],to_user_id: params[:target_id])
    unfollow_data.destroy
    render nothing: true
  end

end
