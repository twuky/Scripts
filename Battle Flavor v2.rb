module Tuckie_BattleFlavor
  # X and Y locations of displayed text, where (0,0) is the top right
  FLTEXT_X =  0
  FLTEXT_Y =  -5

  # Z Value of text. Higher Z-Values place it above other elements.
  FLTEXT_Z = 299

  #--------------------------------------------------------------------------
  # Bar Background
  #   Settings for using an image as the background for the flavor text Bar
  #
  #
  #--------------------------------------------------------------------------

  BLACKBAR   =  false # Enable or disable this feature

  IMAGE_NAME = "BFlavBar" #Name of the file used for the background graphic

  # X and Y OFFSETS of background images.
  BBYOFFSET  = 0
  BBXOFFSET  = 0

  # Z Value of text. Higher Z-Values place it above other elements.
  IMAGE_Z    = 30
  #--------------------------------------------------------------------------
  # TEXT CUSTOMIZATION
  #   Each Entry into the array below represents the set of quotes for one
  #   troop.
  #   The first Entry are phrases that will display if you have not
  #   created an array for an enemy yet. (i.e if the enemy id is higher than
  #   the number of arrays you have set.
  #--------------------------------------------------------------------------


    ENEMY_FLAVOR =[

      ["hi twitter @plsvotetuckie"], # Default Phrases. Array index 0


    ]# End of flavors

end #Keep this here!! ;)

  #--------------------------------------------------------------------------
  # * Window that displays flavor text
  #--------------------------------------------------------------------------

class BattleFlavorWindow < Window_Base

  def initialize
    super(-8, -12, 656, 480)
    reset_pos()
    self.z = 299
    self.back_opacity = 0
    self.opacity = 0
    @base_x = Tuckie_BattleFlavor::FLTEXT_X
    @base_y = Tuckie_BattleFlavor::FLTEXT_Y
  end

  def update
    destroy if $game_party.members.empty?
    destroy if $game_party.all_dead?
    destroy if $game_troop.all_dead?
    super
  end

  def gettroopid
    flavortroop = $game_troop.alive_members.sample.enemy_id
    if Tuckie_BattleFlavor::ENEMY_FLAVOR[flavortroop] != nil
      return Tuckie_BattleFlavor::ENEMY_FLAVOR[flavortroop].sample
    else
      return Tuckie_BattleFlavor::ENEMY_FLAVOR[0].sample
    end
  end

  def change_text (string = "No Text Detected")
    return unless string.is_a?(String)
    destroy
    set_text(string)
    #draw_text( @base_x, @base_y, 640, 32, string, 0)
  end

  def draw_text(x, y, text_width, text_height, string, allignment = 0)
    contents.draw_text(x, y, text_width, text_height, string, allignment)
  end

  def destroy
    contents.clear
    reset_pos()
  end

  def reset_pos()
    @pos = 0
    @animchars = []
    @rainbow = false
    @anim_offset = 0
  end

  #--------------------------------------------------------------------------
  # * Animated Character Processing | New Method
  #--------------------------------------------------------------------------
  def process_anim_character(c)
    text_width = text_size(c).width
    if defined? Graphics.fullscreen #MKXP fix
      text_width += text_width * 0.6
      text_width = text_width.round
    end
    letter = Sprite_TextAnim.new(self.viewport)
    bitmap = Bitmap.new(text_width, 16)
    bitmap.font = self.contents.font
    letter.bitmap = bitmap
    letter.x = pos + @base_x
    letter.y = @base_y
    letter.z = self.z + 10
    letter.anim_offset = @animchars.size
    letter.anim_type = @anim_type
    tuckie_extra(letter)
    letter.update
    bitmap.draw_text(0, 0, 10, 16, c)
    @animchars.push(letter)
    @pos += text_width
  end

  def set_text(string)
    i = 0
    until i = string.length do
      Escape::scan_at(i, string)
      
    end
  end

end #class BattleFlavorWindow

  #--------------------------------------------------------------------------
  # * Create flavor text window on battle start
  #--------------------------------------------------------------------------
class Scene_Battle < Scene_Base

  alias tuckie_flavor_init initialize
  def initialize(*args)
    tuckie_flavor_init(*args)
    @window = BattleFlavorWindow.new
  end # initialize

  alias tuckie_drawflavorwindow   start_party_command_selection
  def start_party_command_selection
    tuckie_drawflavorwindow()
    @window.change_text(@window.gettroopid)
  end # create_all_windows

  alias tuckie_turn_start turn_start
  def turn_start
    tuckie_turn_start()
    @window.destroy() if @window != nil
  end

  alias tuckie_flavorescape command_escape
  def command_escape
    @window.dispose
    tuckie_flavorescape()
  end

  alias tuckie_flavor_terminate terminate
  def terminate
    @window.dispose
    tuckie_flavor_terminate()
  end

end# class BattleFlavor
