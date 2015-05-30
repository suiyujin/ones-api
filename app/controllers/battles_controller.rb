class BattlesController < ApplicationController
  protect_from_forgery except: [ :addVotenum]

  def getBattleInfo

    @my_battle = params[:my_battle]
    @my_battle = Battle.find(params[:my_battle])
    @article1 = Article.find_by(@my_battle.article1_id)
    @article2 = Article.find_by(@my_battle.article2_id)

    render :json => @article2


  end

end
