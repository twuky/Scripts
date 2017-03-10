# tuckies super basic system for stuff like minigames 🌵 :< 🌵

# use these to get variables in (thank u hime)
# $game_variables[27]   # Stores the user of an action
# $game_variables[28]   # Stores the current target of an action
# $game_variables[29]   # stores the used skill
# $game_variables[30]   # Stores the used item

class Minigame_Base
  def initialize()
    #------ should set these up when making customs
    @sprites   = []
    @mg_length = 0
    #------
    get_usey_infotoids()
    setup() # user setup for minigame subclass
    minigame_loop()
    close()
  end

  def setup()

  end

  def minigame_loop

  end

  def get_usey_infotoids()
    # get user (of skill or item or whatever idk)
    if $game_temp.user.actor?
      @user = $game_temp.user.instance_variable_get(:@actor_id)
    else
      @user = $game_temp.user.index
    end
    # get target WHOS BEIN HIT??? (✨_✨)✋
    if $game_temp.target.actor?
      @target = $game_temp.target.instance_variable_get(:@actor_id)
    else
      @target = $game_temp.target.index
    end
    #more stuff here later??
  end

  def close()
    @sprites.each do |sprite|
      sprite.dispose
    end
    @sprites = []
  end

end

class Scene_Battle < Scene_Base

  def run_minigame(num)
    case num
      when 0
        msgbox_p("yo, it works!")
      when 1

    end
  end

  alias tuckie_minigame_use_item use_item
  def use_item
    item = @subject.current_action.item
    if item.note =~ /<minigame:[ ](\d+)>/
      ($1.to_i)
    end
    tuckie_minigame_use_item
  end
end
