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

  def addVotenum

    @my_battle = Battle.find(params[:my_battle])
    if params[:vote_id].to_i == 1 then
      @current_votenum = @my_battle.vote1_num
      @plus_votenum = @current_votenum + 1
      @my_battle.update_attribute( :vote1_num, @plus_votenum )
    else
      @current_votenum = @my_battle.vote2_num
      @plus_votenum = @current_votenum + 1
      @my_battle.update_attribute( :vote2_num, @plus_votenum )
    end

  end

end