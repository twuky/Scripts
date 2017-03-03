


#==============================================================================
  module WindowJem # dont ✂️ this
#------------------------------------------------------------------------------
# ** Default settings
#    The settings for this script will resort to
#==============================================================================

  Sprites = [
    [Cache.system("Jem_normal.png"), Cache.system("Jem_normal_1.png")],
    [Cache.system("Jem_kiss.png"), Cache.system("Jem_kiss_1.png")]
  ]

  CONFIG = { # 👏 do 👏 not 👏 delete 👏 this 👏 pls 👏

    img_src     => Sprites[0] # 📷

    speed       => 0.1

    #---------------------------------------------------------------------------
    shake       => false
    shake_pow   => 4
    shake_len   => 8
    #---------------------------------------------------------------------------
    angle_max   => 20

    height_max  => 16

    width_max   => 4
  } # keep this curly boy, keep him safe forever :)

end

#==============================================================================
# ** Sprite_jem
#------------------------------------------------------------------------------
#  Sprite subclass for one RAD hat
#==============================================================================

class Sprite_jem < Sprite # 🔥 💎 🔥 it yo boy
  attr_accessor :attributes

  def initialize(attrs)
    @attributes = attrs
    @count = 0
  end

  def jem_bitmap_update(force)

    if force
      self.bitmap = Bitmap.new(@attributes[img_src.sample])
    else
      if @count % 16 == 0 and @count != 0
        self.bitmap = Bitmap.new(@attributes[img_src.sample])
      end

    end

  end

  def update()
    jem_bitmap_update(false)
    self.oy = @attributes[height_max] * Math.sin( @count * @attributes[speed] )
    self.ox = @attributes[width_max]  * Math.sin( @count * @attributes[speed] )    
    @count += 1
  end

end

#==============================================================================
# ** Window_Message
#------------------------------------------------------------------------------
#  This message window is used to display text.
#==============================================================================

class Window_Message < Window_Base
  attr_accessor :attributes

  #--------------------------------------------------------------------------
  # * Window_Message Creation | Alias
  #--------------------------------------------------------------------------
  alias tuckie_jem_initialize initialize
  def initialize
    tuckie_jem_initialize
    @attributes = WindowJem::CONFIG # sets to user setting default
  end

  #--------------------------------------------------------------------------
  # * Control Character Processing | Alias
  #     code : the core of the control character
  #            e.g. "C" in the case of the control character \C[1].
  #--------------------------------------------------------------------------
  alias tuckie_wiggly_process_escape_character process_escape_character
  def process_escape_character(code, text, pos)
    case code.upcase
    when 'HAT' # here comes our hat boy, watch out everyone | starts JEM

    when 'JEM'
      @attributes[img_src] = WindowJem::Sprites[obtain_escape_param(text)]
    when 'JEMSHK' # uh oh bye bye jem see u next time

    when 'JEMOFF'

    end
    tuckie_wiggly_process_escape_character(code, text, pos)
  end

  #--------------------------------------------------------------------------
  # * Close Window and Wait for It to Fully Close | Alias
  #--------------------------------------------------------------------------
  alias tuckie_wiggly_close_wait close_and_wait
  def close_and_wait
    # dude what are u doing NOT haveing a method for getting rid of jem
    tuckie_wiggly_close_wait()
  end
  #--------------------------------------------------------------------------
  # * Close Window and Wait for It to Fully Close | Alias
  #--------------------------------------------------------------------------
  alias tuckie_jem_dispose dispose
  def dispose
    # hey buddo get going on a function for getting rid of jem
    tuckie_wiggly_dispose()
  end
  #--------------------------------------------------------------------------
  # * New Page | Alias
  #--------------------------------------------------------------------------
  alias tuckie_wiggly_new_page new_page
  def new_page(*args)
    #idk meybe this could be useful lol prolly not
    tuckie_wiggly_new_page(*args)
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

  end

end # end of script :) have a nice one thankz for looking
