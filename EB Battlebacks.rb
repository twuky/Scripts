class Earthbound_Back < Sprite
  attr_accessor :amplitude
  attr_accessor :frequency
  attr_accessor :time_scale
  attr_accessor :compression
  attr_accessor :type
  attr_accessor :time
  attr_accessor :count
  attr_accessor :offset
  attr_accessor :timer
  attr_accessor :orig_y
  attr_accessor :slow

  def initialize(*args)
    @timer = 1
    super(*args)
  end

  def update()
    @offset = @amplitude * Math.sin(@frequency * @orig_y + @time * @time_scale)
    @time += 1
    tuckie_eb_update()
  end

  def tuckie_eb_update()
    eb_wave()
    eb_placement()
  end

  def eb_wave()
    case @type
      when 0
        self.ox = @offset
        self.ox -= 1 if self.ox.even?
      when 1
        self.ox = @count.even? ? @offset - 1: -@offset
        self.ox -= 1 if self.ox.even?
      when 2
        newoff = @offset / 2
        self.y = @orig_y * @compression + newoff
        self.y = (self.y + Graphics.height) % Graphics.height
        self.y -= 1 if self.y.even?
        self.y -= 1 if self.y < 2
        self.ox = -1
        self.zoom_y = 2.5
        #@orig_y += 1
    end

  end

  def eb_placement

  end

end
#==============================================================================
# ** Spriteset_Battle
#------------------------------------------------------------------------------
#  This class brings together battle screen sprites. It's used within the
# Scene_Battle class.
#==============================================================================
class Spriteset_Battle

  #--------------------------------------------------------------------------
  # * Move Sprite to Screen Center | new
  #--------------------------------------------------------------------------
  def center_sprite_x(sprite)
    diff = sprite.bitmap.width - Graphics.width
    sprite.x = 0 - diff * 0.5
  end
  #--------------------------------------------------------------------------
  # * Create Battle Background (Floor) Sprite | overwrite
  #--------------------------------------------------------------------------
  def create_battleback1
    count = 0
    @back1_sprite = []
    while count * 2 <= battleback1_bitmap.height - 2 do
      strip = Earthbound_Back.new(@viewport1)
      #set strip boys
      strip.type = 2
      strip.amplitude = 30
      strip.frequency = 0
      strip.time_scale = 0.27926 / 4
      strip.compression = 1
      strip.time = count
      strip.slow = 1
      #get strip image
      strip.bitmap = battleback1_bitmap
      rc = Rect.new(0, count * 2, battleback1_bitmap.width, 2)
      strip.src_rect = rc
      center_sprite_x(strip)
      strip.z = 2
      strip.orig_y = count * 2
      strip.y = count * 2
      strip.count = count
      @back1_sprite.push(strip)
      count += 1
    end
  end
  #--------------------------------------------------------------------------
  # * Create Battle Background (Wall) Sprite
  #--------------------------------------------------------------------------
  def create_battleback2
    count = 0
    @back2_sprite = []
    while count * 2 <= battleback2_bitmap.height - 2 do
      strip = Earthbound_Back.new(@viewport1)
      #set strip boys
      strip.type = 1
      strip.slow = 2
      strip.amplitude = 12
      strip.frequency = 0
      strip.time_scale = 0.27926 / 4
      strip.compression = 1
      strip.time = count
      strip.orig_y = count * 2
      #get strip image
      strip.bitmap = battleback2_bitmap
      rc = Rect.new(0, count * 2, battleback2_bitmap.width, 2)
      strip.src_rect = rc
      center_sprite_x(strip)
      strip.z = 4
      strip.count = count
      strip.y = count * 2
      @back2_sprite.push(strip)
      count += 1
    end
  end
  #--------------------------------------------------------------------------
  # * Get Battle Background (Floor) Bitmap
  #--------------------------------------------------------------------------
  def battleback1_bitmap
    if battleback1_name
      Cache.battleback1(battleback1_name)
    else
      create_blurry_background_bitmap
    end
  end
  #--------------------------------------------------------------------------
  # * Get Battle Background (Wall) Bitmap
  #--------------------------------------------------------------------------
  def battleback2_bitmap
    if battleback2_name
      Cache.battleback2(battleback2_name)
    else
      Bitmap.new(1, 1)
    end
  end
  #--------------------------------------------------------------------------
  # * Get Filename of Battle Background (Floor)
  #--------------------------------------------------------------------------
  def battleback1_name
    if $BTEST
      $data_system.battleback1_name
    elsif $game_map.battleback1_name
      $game_map.battleback1_name
    elsif $game_map.overworld?
      overworld_battleback1_name
    end
  end
  #--------------------------------------------------------------------------
  # * Get Filename of Battle Background (Wall)
  #--------------------------------------------------------------------------
  def battleback2_name
    if $BTEST
      $data_system.battleback2_name
    elsif $game_map.battleback2_name
      $game_map.battleback2_name
    elsif $game_map.overworld?
      overworld_battleback2_name
    end
  end
  #--------------------------------------------------------------------------
  # * Free Battle Background (Floor) Sprite
  #--------------------------------------------------------------------------
  def dispose_battleback1
    @back1_sprite.each { |bb| bb.dispose() }
    @back1_sprite = []
  end
  #--------------------------------------------------------------------------
  # * Free Battle Background (Wall) Sprite
  #--------------------------------------------------------------------------
  def dispose_battleback2
    @back2_sprite.each { |bb| bb.dispose() }
    @back2_sprite = []
  end
  #--------------------------------------------------------------------------
  # * Update Battle Background (Floor) Sprite
  #--------------------------------------------------------------------------
  def update_battleback1
    unless @back1_sprite.empty?
      @back1_sprite.each { |bb| bb.update() }
    end
  end
  #--------------------------------------------------------------------------
  # * Update Battle Background (Wall) Sprite
  #--------------------------------------------------------------------------
  def update_battleback2
    unless @back2_sprite.empty?
      @back2_sprite.each { |bb| bb.update() }
    end
  end
end
