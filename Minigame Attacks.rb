# tuckies super basic system for stuff like minigames 🌵 :< 🌵

# use these to get variables in (thank u hime)
# $game_variables[27]   # Stores the user of an action
# $game_variables[28]   # Stores the current target of an action
# $game_variables[29]   # stores the used skill
# $game_variables[30]   # Stores the used item

class Minigame_Base
  def initialize(a, b)

    setup() # user setup for minigame subclass
    minigame_loop()
    close()
  end

  def setup()
    msgbox_p(@target)
  end

  def minigame_loop

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
        @test = Minigame_Base.new(:@actor_id)
      when 1

    end
  end

  alias tuckie_minigame_use_item use_item
  def use_item
    item = @subject.current_action.item
    if item.note =~ /<minigame:[ ](\d+)>/
    run_minigame($1.to_i)
    end
    tuckie_minigame_use_item
  end
end
