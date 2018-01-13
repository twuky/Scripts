class Game_Cursor

  # Attribute Accessors ------#
  attr_accessor :mouse_x      #
  attr_accessor :mouse_y      #
  attr_accessor :mouse_click  #
  attr_accessor :mouse_hold   #
  attr_accessor :hold_count   #
  attr_accessor :mouse_sprite #
  attr_accessor :trail_on     #
  #---------------------------#

  def initialize()
    Graphics.show_cursor = false
    create_mouse_cursor()
    @count = 0
    @hold_count = 0
    @trail_c = 0
    @trail = []
    @trailmax = 5
    @trail_on = true
  end

  def create_mouse_cursor()
    tag = Sprite.new()
    tag.bitmap = Cache.system("MouseCursor")
    tag.ox = 8
    tag.oy = 4
    tag.x  =  Input.mouse_x
    tag.y  =  Input.mouse_y
    tag.z  = 9999
    @zoom  = 0
    @mouse_sprite = tag
  end

  def determine_click()
    clicked_this_frame = Input.press? (:MOUSELEFT)
    @hold_count += 1 if  clicked_this_frame
    @hold_count  = 0 if !clicked_this_frame
    @mouse_click = @hold_count > 6 ? false : true
    @mouse_hold  = @hold_count > 4 ? true : false
    @mouse_click = false if @mouse_hold
  end

  def update()
    @mouse_x = Input.mouse_x if Input.mouse_x < Graphics.width
    @mouse_y = Input.mouse_y if Input.mouse_y < Graphics.height
    update_sprite_loc()
    update_trail()
    determine_click()
    click_animation()
    @count += 1
  end

  def update_sprite_loc()
    @mouse_sprite.x = @mouse_x
    @mouse_sprite.y = @mouse_y
  end

  def update_trail()
    if !@trail_on
      @trail.each do |sprite|
        sprite.dispose if sprite.is_a? Sprite
        sprite.z -= 1 if sprite.z <= 9990
      end
    end
    if @count % 3 == 0
      @trail[@trail_c].dispose if @trail[@trail_c].is_a? Sprite and !@trail[@trail_c].grabbed
      if @trail_on
        tag = Mouse_Trail.new(12)
        tag.bitmap = Cache.system("MouseCursor")
        tag.ox = 8
        tag.oy = 4
        tag.x  =  @mouse_x
        tag.y  =  @mouse_y
        tag.z  = 9998
        @mouse_sprite.zoom_x = 1
        @mouse_sprite.zoom_y = 1
        @trail[@trail_c] = tag
      end
      @trail.each do |sprite|
        sprite.z -= 1 if sprite.z <= 9990
      end
      @trail_c += 1
      @trail_c = 0 if @trail_c == @trailmax
    end
  end

  def click_animation()
    @mouse_sprite.zoom_x = 1 + @zoom
    @mouse_sprite.zoom_y = 1 + @zoom
    @mouse_sprite.ox = 8 + @zoom * 3
    @mouse_sprite.oy = 4 + @zoom * 4
    @zoom *= 0.7
    @zoom  = 0.6 if @hold_count == 1
  end
end

module DataManager

  class << self # or, class << MyModule
    alias tuckie_creategameobj create_game_objects
    def create_game_objects()
      tuckie_creategameobj()
      $game_cursor = Game_Cursor.new if defined? Graphics.fullscreen #MKXP
    end
  end

end

module Graphics

  class << self
    alias tuckie_mouse_update update
    def update()
    $game_cursor.update if defined? Graphics.fullscreen #MKXP
    tuckie_mouse_update()
    end
  end

end

class Mouse_Trail < Sprite
  attr_accessor :grabbed

  def initialize()
    super
    @grabbed = false
  end

  def update
    super
    if @grabbed
      @timer = 0 unless !
      defined? @timer
    end
  end

end
