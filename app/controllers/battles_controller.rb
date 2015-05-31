class BattlesController < ApplicationController
  protect_from_forgery except: [ :addVotenum]

  def getBattlesList
    battles_list = Battle.all.map do |battle|
      battle_hash = battle.attributes
      battle_hash['article1_image'] = battle.article1.image_path
      battle_hash['article2_image'] = battle.article2.image_path
      battle_hash
    end

    if battles_list.blank?
      res = {
        result: false,
        data: nil
      }
    else
      res = {
        result: true,
        data: battles_list
      }
    end

    render json: res
  end

  def getBattleInfo
    login_user_id = params[:my_id]
    login_user = User.find(login_user_id)
    battle_id = params[:battle_id]

    my_battle = Battle.find(battle_id)
    articles_hash = make_articles_hash([my_battle.article1, my_battle.article2], login_user)

    if articles_hash.blank?
      res = {
        result: false,
        data: nil
      }
    else
      res = {
        result: true,
        data: {
          login_user_id: login_user_id,
          battle_id: battle_id,
          articles: articles_hash
        }
      }
    end

    render json: res
  end

  def addVotenum
    battle_id = params[:battle_id].to_i
    article_id = params[:article_id].to_i

    my_battle = Battle.find(battle_id)
    if my_battle.article1_id == article_id
      current_votenum = my_battle.vote1_num
      plus_votenum = current_votenum + 1
      my_battle.update_attribute( :vote1_num, plus_votenum )
    elsif my_battle.article2.id == article_id
      current_votenum = my_battle.vote2_num
      plus_votenum = current_votenum + 1
      my_battle.update_attribute( :vote2_num, plus_votenum )
    end

    render json: {result: true}
  end

end
