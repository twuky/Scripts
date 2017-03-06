


#==============================================================================
  module WindowJem # dont ✂️ this | for dj 📎📎
#------------------------------------------------------------------------------
# ** Default settings
#    The settings for this script will resort to
#==============================================================================

  Sprites = [
    ["Graphics/System/Jem_normal.png", "Graphics/System/Jem_normal_1.png"], # 0
    #[Cache.system("Jem_kiss.png"), Cache.system("Jem_kiss_1.png")]
  ]

    SPEED       = 0.1
    #---------------------------------------------------------------------------
    SHAKE       = false
    SHAKE_POW   = 4
    SHAKE_LEN   = 8
    #---------------------------------------------------------------------------
    ANGLE_MAX   = 4
    HEIGHT_MAX  = 12
    WIDTH_MAX   = -12

end

#==============================================================================
# ** Sprite_jem
#------------------------------------------------------------------------------
#  Sprite subclass for one RAD hat
#==============================================================================

class Sprite_jem < Sprite # 🔥 💎 🔥 it yo boy
    attr_accessor :img_src
    attr_accessor :speed
    attr_accessor :shake
    attr_accessor :shake_pow
    attr_accessor :shake_len
    #---------------------------------------------------------------------------
    attr_accessor :angle_max
    attr_accessor :height_max
    attr_accessor :width_max

  def initialize(*args)
    @count = 0
    set_offset()
    super(*args)
  end

  def set_offset()
    @off_x = 80
  end

  def update(*args)
    self.bitmap = Bitmap.new(@img_src.sample) if @count % 8 == 0
    self.oy     = @height_max * Math.sin(@count * 0.1)
    self.ox     = @width_max  * Math.cos(@count * 0.025)
    self.angle  = @angle_max  * Math.cos(@count * 0.1)
    self.ox += @off_x
    @off_x = @off_x * 0.94
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
    attr_accessor :img_src
    attr_accessor :speed
    attr_accessor :shake
    attr_accessor :shake_pow
    attr_accessor :shake_len
    #---------------------------------------------------------------------------
    attr_accessor :angle_max
    attr_accessor :height_max
    attr_accessor :width_max

  #--------------------------------------------------------------------------
  # * Window_Message Creation | Alias
  #--------------------------------------------------------------------------
  alias tuckie_jem_initialize initialize
  def initialize
    tuckie_jem_initialize
    get_attributes()
  end

  #--------------------------------------------------------------------------
  # * get attributes | New Method
  #--------------------------------------------------------------------------
  def get_attributes
   @img_src    = WindowJem::Sprites[0]
   @speed      = WindowJem::SPEED
   @shake      = WindowJem::SHAKE
   @shake_pow  = WindowJem::SHAKE_POW
   @shake_len  = WindowJem::SHAKE_LEN
   @angle_max  = WindowJem::ANGLE_MAX
   @height_max = WindowJem::HEIGHT_MAX
   @width_max  = WindowJem::WIDTH_MAX
  end

  #--------------------------------------------------------------------------
  # * Jem sprite creation | New Method
  #--------------------------------------------------------------------------
  def create_jem()
    @jem = Sprite_jem.new()
    #bitmap          = Bitmap.new("Graphics/System/Jem_normal.png")
    #@jem.bitmap     = bitmap
    @jem.img_src    = @img_src
    @jem.speed      = @speed
    @jem.shake      = @shake
    @jem.shake_pow  = @shake_pow
    @jem.shake_len  = @shake_len
    @jem.angle_max  = @angle_max
    @jem.height_max = @height_max
    @jem.width_max  = @width_max

    @jem.x =  380
    @jem.y =  20
    @jem.z = 500
    @jem.visible = true
  end

  #--------------------------------------------------------------------------
  # * Control Character Processing | Alias
  #     code : the core of the control character
  #            e.g. "C" in the case of the control character \C[1].
  #--------------------------------------------------------------------------
  alias tuckie_jem_process_escape_character process_escape_character
  def process_escape_character(code, text, pos)
    case code.upcase
    when 'HAT' # here comes our hat boy, watch out everyone | starts JEM
      create_jem()
    when 'JEM'
      @img_src = WindowJem::Sprites[obtain_escape_param(text)]
    when 'JEMSHK'

    when 'JEMOFF' # uh oh bye bye jem see u next time
      jem_dispose()
    end
    tuckie_jem_process_escape_character(code, text, pos)
  end

  #--------------------------------------------------------------------------
  # * Close Window and Wait for It to Fully Close | Alias
  #--------------------------------------------------------------------------
  def jem_dispose()
    @jem.dispose() if defined? @jem != nil
    @jem = Sprite_jem.new
    @jem.visible = false
    get_attributes()
  end

  #--------------------------------------------------------------------------
  # * Close Window and Wait for It to Fully Close | Alias
  #--------------------------------------------------------------------------
  alias tuckie_jem_close_wait close_and_wait
  def close_and_wait
    jem_dispose()
    tuckie_jem_close_wait()
  end

  #--------------------------------------------------------------------------
  # * Close Window and Wait for It to Fully Close | Alias
  #--------------------------------------------------------------------------
  alias tuckie_jem_dispose dispose
  def dispose
    jem_dispose()
    tuckie_wiggly_dispose()
  end

  #--------------------------------------------------------------------------
  # * New Page | Alias
  #--------------------------------------------------------------------------
  alias tuckie_jem_new_page new_page
  def new_page(*args)
    @img_src = WindowJem::Sprites[0]
    tuckie_jem_new_page(*args)
  end

  #--------------------------------------------------------------------------
  # * Window Update | Alias
  #--------------------------------------------------------------------------
  alias tuckie_jem_update update
  def update
    update_jem()
    tuckie_jem_update()
  end

  #--------------------------------------------------------------------------
  # * Text Animation Processing | New Method
  #--------------------------------------------------------------------------
  def update_jem()
    if defined? @jem != nil

      @jem.img_src    = @img_src
      @jem.speed      = @speed
      @jem.shake      = @shake
      @jem.shake_pow  = @shake_pow
      @jem.shake_len  = @shake_len
      @jem.angle_max  = @angle_max
      @jem.height_max = @height_max
      @jem.width_max  = @width_max

      @jem.update
    end
  end

end # end of script :) have a nice one thankz for looking
