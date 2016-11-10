#==============================================================================
# ** SETTINGS
#==============================================================================

module WiggleText

  # Characters 'drop in' when first drawn.
  # This affects all characters drawn, even characters without any animation.
  DROP_IN     = true
  # Height from where characters drop.
  DROP_HEIGHT = 8

  # Enable or disable hitting a button to skip drawing characters one-by-one.
  # true means players can skip, false means they can't.
  SKIP_CHAR   = true

  # If using Galv's message background script,
  # This will add a subtle floating effect to the text box, and all
  # characters inside. PLACE THIS SCRIPT BELOW GALV'S MESSAGE BACKGROUND.
  GALV_ANI    = false
end

#==============================================================================
# ** Sprite_TextAnim
#------------------------------------------------------------------------------
#  Sprite subclass for text animations.
#==============================================================================

class Sprite_TextAnim < Sprite

  attr_accessor :anim_offset
  attr_accessor :anim_type
  attr_accessor :rainbow
  attr_accessor :rainbow_offset
  attr_accessor :drop
  @timer      = false
  attr_accessor :galv_ani


  def ani
    self.oy = @drop
    @drop -= @drop * 0.16
    if @drop < 0
      @drop = 0
    end
    if WiggleText::GALV_ANI
      @galv_ani += 0.05
      self.oy = self.oy + Math.sin(@galv_ani) * 3
    end
  end

  def update
    return unless @anim_offset

    if @rainbow
      @rainbow_offset += 0.03
      self.color = Color.new(128 + Math.sin(@rainbow_offset) * 127,
        128 + Math.sin(@rainbow_offset + 2*Math::PI/3) * 127,
        128 + Math.sin(@rainbow_offset + 4*Math::PI/3) * 127,
        255)
    end
    case @anim_type
      when 1
        @anim_offset += 0.115
        self.oy = Math.sin(@anim_offset) * 3
        ani()
      when 2
        @anim_offset += 0.2
        self.ox = Math.sin(@anim_offset) * 3
        self.oy = Math.cos(@anim_offset) * -3
        ani()
      when 3
        @anim_offset += 0.15
        self.zoom_x = 1 + Math.sin(@anim_offset) * 0.2
        self.zoom_y = 1 + Math.cos(@anim_offset) * 0.2
        ani()
      when 4
        if @timer
        self.ox = rand(2) - rand(2)
        self.oy = rand(2) - rand(2)
        end
        @timer = !@timer
        ani()
      when 5
        @anim_offset += 0.1
        sample  = Math.sin(@anim_offset) * 5
        self.oy = sample.abs
        ani()
      when 6
        @anim_offset += 0.1
        self.ox = Math.sin(@anim_offset) * 3
        self.oy = Math.cos(@anim_offset) * -2
        self.angle = Math.sin(@anim_offset * 0.5) * 10
        ani()
      when 7
        #no animation
        ani()
      when 8
        @anim_offset += 0.1
        self.ox = Math.sin(@anim_offset) * 3
        self.oy = Math.cos(@anim_offset) * -2
        self.angle = Math.sin(@anim_offset) * 10
      else
        return
    end
  end

end

#==============================================================================
# ** Window_Message
#------------------------------------------------------------------------------
#  This message window is used to display text.
#==============================================================================

class Window_Message < Window_Base

  #--------------------------------------------------------------------------
  # * Window_Message Creation | Alias
  #--------------------------------------------------------------------------
  alias tuckie_wiggly_initialize initialize
  def initialize
    tuckie_wiggly_initialize
    @animchars = []
    @rainbow = false
    @anim_offset = 0
  end

  #--------------------------------------------------------------------------
  # * Normal Character Processing | Overwrite
  #--------------------------------------------------------------------------
  def process_normal_character(c, pos)
    if @anim_type && @anim_type > 0
      process_anim_character(c, pos)
    else
      if WiggleText::GALV_ANI or WiggleText::DROP_IN
        @anim_type = 7
        process_anim_character(c, pos)
      else
        super
      end
    end
    wait_for_one_character
  end

  #--------------------------------------------------------------------------
  # * Animated Character Processing | New Method
  #--------------------------------------------------------------------------
  def process_anim_character(c, pos)
    text_width = text_size(c).width
    letter = Sprite_TextAnim.new(self.viewport)
    bitmap = Bitmap.new(text_width * 2, pos[:height])
    bitmap.font = self.contents.font
    #
    letter.bitmap = bitmap
    letter.x = pos[:x] + self.standard_padding
    letter.y += WiggleText::DROP_HEIGHT if WiggleText::DROP_IN
    letter.y = self.y + standard_padding + pos[:y]
    letter.z = self.z + 10
    letter.anim_offset = @animchars.size
    letter.anim_type = @anim_type
    tuckie_extra(letter)
    letter.update
    bitmap.draw_text(0, 0, text_width * 2, pos[:height], c)
    @animchars.push(letter)
    pos[:x] += text_width
  end
  #--------------------------------------------------------------------------
  # * Animated Character Extra Conditions | New Method
  #--------------------------------------------------------------------------
  def tuckie_extra(letter)
    if WiggleText::DROP_IN
      letter.drop = WiggleText::DROP_HEIGHT
    else
      letter.drop = 0
    end
    if @anim_type == 5
      letter.anim_offset = 0
    end
    letter.galv_ani = get_galvani
    if @rainbow
      letter.rainbow = true
      letter.rainbow_offset = @animchars.size * 0.5
    end
    if @anim_type == 5
      letter.anim_offset = 0
    end
    letter.galv_ani = get_galvani
    if @rainbow
      letter.rainbow = true
      letter.rainbow_offset = @animchars.size * 0.5
    end
  end
  #--------------------------------------------------------------------------
  # * Control Character Processing | Alias
  #     code : the core of the control character
  #            e.g. "C" in the case of the control character \C[1].
  #--------------------------------------------------------------------------
  alias tuckie_wiggly_process_escape_character process_escape_character
  def process_escape_character(code, text, pos)
    case code.upcase
    when 'ANI' # Text Animation (by number)
      @anim_type = obtain_escape_param(text)
    when 'OFF' # No Text Animation
      if WiggleText::GALV_ANI or WiggleText::DROP_IN
        @anim_type = 7
      end
      @rainbow = false
    when 'WAV' # Wave animation
      @anim_type = 1
    when 'SHK' # Shake Screen
      $game_map.screen.start_shake(obtain_escape_param(text), 15, 10)
    when 'RAN'
      @rainbow = true
    when 'BLN'
      @rainbow = false
    end
    tuckie_wiggly_process_escape_character(code, text, pos)
  end

  #--------------------------------------------------------------------------
  # * Close Window and Wait for It to Fully Close | Alias
  #--------------------------------------------------------------------------
  alias tuckie_wiggly_close_wait close_and_wait
  def close_and_wait
    dispose_text_animation()
    tuckie_wiggly_close_wait()
  end
  #--------------------------------------------------------------------------
  # * Close Window and Wait for It to Fully Close | Alias
  #--------------------------------------------------------------------------
  alias tuckie_wiggly_dispose dispose
  def dispose
    dispose_text_animation()
    tuckie_wiggly_dispose()
  end
  #--------------------------------------------------------------------------
  # * New Page | Alias
  #--------------------------------------------------------------------------
  alias tuckie_wiggly_new_page new_page
  def new_page(*args)
    dispose_text_animation()
    tuckie_wiggly_new_page(*args)
  end
  #--------------------------------------------------------------------------
  # * Free animated text | New Method
  #--------------------------------------------------------------------------
  def dispose_text_animation
    @animchars.each do |letter|
      letter.dispose
    end
    @animchars = []
  end
  #--------------------------------------------------------------------------
  # * Update Fast Forward Flag | Alias
  #--------------------------------------------------------------------------
  alias tuckie_wiggle_update_show_fast update_show_fast
  def update_show_fast
    tuckie_wiggle_update_show_fast()
    @show_fast = false if !WiggleText::SKIP_CHAR
  end
  #--------------------------------------------------------------------------
  # * Galv Animated Textbox | Alias
  #--------------------------------------------------------------------------
  alias tuckie_wiggly_create_back_bitmap create_back_bitmap
  def create_back_bitmap
    @anim_offset = 0
    tuckie_wiggly_create_back_bitmap()
  end

  alias tuckie_wiggle_update_back_sprite update_back_sprite
  def update_back_sprite
    if WiggleText::GALV_ANI
      tuckie_update()
    end
    tuckie_wiggle_update_back_sprite
  end

  def get_galvani
    return @anim_offset
  end
  def tuckie_update
    @anim_offset += 0.05
    @bg.oy = Math.sin(@anim_offset) * 3
  end
  #--------------------------------------------------------------------------
  # * Window Update | Alias
  #--------------------------------------------------------------------------
  alias tuckie_wiggly_update_base update
  def update
    update_text_animation()
    tuckie_wiggly_update_base()
  end
  #--------------------------------------------------------------------------
  # * Text Animation Processing | New Method
  #--------------------------------------------------------------------------
  def update_text_animation()
    unless @animchars.empty?
      @animchars.each do |letter|
        letter.update
      end
    end
  end

end
