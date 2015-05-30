class BattlesController < ApplicationController
  protect_from_forgery except: [ :addVotenum]

  def getBattlesList
    battles_list = Battle.all.map(&:attributes)
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

end
