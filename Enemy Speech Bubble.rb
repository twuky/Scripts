#==============================================================================
  module Window_msg_bubble # dont ✂️ this | for dj 📎📎
#------------------------------------------------------------------------------
# ** Default settings
#    The settings for this script will resort to
#==============================================================================

  Sprites = [
    ["Graphics/System/msg_bubble_normal.png",
     "Graphics/System/msg_bubble_normal.png"], # 0
    #[Cache.system("msg_bubble_kiss.png"), Cache.system("msg_bubble_kiss_1.png")]
  ]

end

#==============================================================================
# ** Sprite_msg_bubble
#------------------------------------------------------------------------------
#  Sprite subclass for one RAD hat
#==============================================================================

class Sprite_msg_bubble < Sprite # 🔥 💎 🔥 it yo boy
#==========================#
    attr_accessor :img_src #
    attr_accessor :mbb_x_off   #
    attr_accessor :mbb_y_off   #
    attr_accessor :target  #
#==========================#

  def initialize(*args)
    @count = 0
    super(*args)
  end

  def update(*args)
    self.bitmap =  Bitmap.new("Graphics/System/msg_bubble_normal.png") #if @count % 8 == 0
    self.oy     =  @mbb_y_off
    self.ox     =  @mbb_x_off
    @count += 1
    super(*args)
  end

end

#==============================================================================
# ** Window_Message
#------------------------------------------------------------------------------
#  This message window is used to display text.
#==============================================================================

class Window_Message < Window_Base
  #==========================#
      attr_accessor :img_src #
      attr_accessor :mbb_x_off   #
      attr_accessor :mbb_y_off   #
      attr_accessor :target  #
  #==========================#

  #--------------------------------------------------------------------------
  # * Window_Message Creation | Alias
  #--------------------------------------------------------------------------
  alias tuckie_msg_bubble_initialize initialize
  def initialize
    tuckie_msg_bubble_initialize
    get_attributes()
  end

  #--------------------------------------------------------------------------
  # * get attributes | New Method
  #--------------------------------------------------------------------------
  def get_attributes
   #@img_src    = Window_msg_bubble::Sprites[0]
   @mbb_x_off      = 0
   @mbb_y_off      = 0
  end

  #--------------------------------------------------------------------------
  # * msg_bubble sprite creation | New Method
  #--------------------------------------------------------------------------
  def create_msg_bubble()
    #@msg_bubble.img_src    = @img_src
    @msg_bubble = Sprite_msg_bubble.new()
    @msg_bubble.x =  $game_troop.members[$game_variables[28]].screen_x - 32
    @msg_bubble.y =  Graphics.height / 2 - 32 #$game_troop.members[$game_variables[28]].screen_y
    @msg_bubble.z =  500
    @msg_bubble.visible = true
  end

  #--------------------------------------------------------------------------
  # * Control Character Processing | Alias
  #     code : the core of the control character
  #            e.g. "C" in the case of the control character \C[1].
  #--------------------------------------------------------------------------
  alias tuckie_msg_bubble_process_escape_character process_escape_character
  def process_escape_character(code, text, pos)
    case code.upcase
    when 'MBL' # here comes our hat boy, watch out everyone | starts msg_bubble
      create_msg_bubble()
    when 'MB_X'
      @mbb_x_off    = obtain_escape_param(text)
    when 'MB_Y'
      @mbb_y_off    = obtain_escape_param(text)
    when 'MBLOFF' # uh oh bye bye msg_bubble see u next time
      msg_bubble_dispose()
    end
    tuckie_msg_bubble_process_escape_character(code, text, pos)
  end

  #--------------------------------------------------------------------------
  # * Close Window and Wait for It to Fully Close | Alias
  #--------------------------------------------------------------------------
  def msg_bubble_dispose()
    @msg_bubble.dispose() if defined? @msg_bubble != nil
    @msg_bubble = Sprite_msg_bubble.new
    @msg_bubble.visible = false
    get_attributes()
  end

  #--------------------------------------------------------------------------
  # * Close Window and Wait for It to Fully Close | Alias
  #--------------------------------------------------------------------------
  alias tuckie_msg_bubble_close_wait close_and_wait
  def close_and_wait
    msg_bubble_dispose()
    tuckie_msg_bubble_close_wait()
  end

  #--------------------------------------------------------------------------
  # * Close Window and Wait for It to Fully Close | Alias
  #--------------------------------------------------------------------------
  alias tuckie_msg_bubble_dispose dispose
  def dispose
    msg_bubble_dispose()
    tuckie_wiggly_dispose()
  end

  #--------------------------------------------------------------------------
  # * New Page | Alias
  #--------------------------------------------------------------------------
  alias tuckie_msg_bubble_new_page new_page
  def new_page(*args)
    #@img_src = Window_msg_bubble::Sprites[0]
    msg_bubble_dispose()
    tuckie_msg_bubble_new_page(*args)
  end

  #--------------------------------------------------------------------------
  # * Window Update | Alias
  #--------------------------------------------------------------------------
  alias tuckie_msg_bubble_update update
  def update
    update_msg_bubble()
    tuckie_msg_bubble_update()
  end

  #--------------------------------------------------------------------------
  # * Text Animation Processing | New Method
  #--------------------------------------------------------------------------
  def update_msg_bubble()
    if defined? @msg_bubble != nil
      @msg_bubble.mbb_x_off = @mbb_x_off
      @msg_bubble.mbb_y_off = @mbb_y_off
      @msg_bubble.update
    end
  end

end # end of script :) have a nice one thankz for looking
