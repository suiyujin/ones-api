class BattlesController < ApplicationController
  protect_from_forgery except: [ :addVotenum]

  def getBattleInfo

    @my_battle = Battle.find(params[:my_battle])
    @my_battle_array = [@my_battle.article1,@my_battle.article2]
    @json_battle_array = Hash.new
    @json_battle_array["result"] = true
    @json_battle_array["data"] = @my_battle_array

    render :json => @json_battle_array

  end

end
