
#==============================================================================
# ** Earthbound_Back
#------------------------------------------------------------------------------
#  This class is a modification of the Sprite class with built-in functionality
#  to animate along a sinewave, for those trippy battlebacks that are so in
#  these days 🎮🎮🎮🎮
#==============================================================================
class Earthbound_Back < Sprite
#--------------------------------------------------------------------------
# * Attribute Accessor setup
#--------------------------------------------------------------------------
  attr_accessor :time
  attr_accessor :count
  attr_accessor :offset
  attr_accessor :timer
  attr_accessor :orig_y
  attr_accessor :bb_num
  attr_accessor :config
  attr_accessor :orig_bitmap
#--------------------------------------------------------------------------
# * Initialize
#--------------------------------------------------------------------------
  def initialize(*args)
    @val = 0 #variable to hold end value
    @time = 0
    @sync_time = 0
    @anim_forward = true
    @timer = 1
    @bg_count = 0
    @scroll_x = 0
    @scroll_y = 0
    super(*args)
  end
#--------------------------------------------------------------------------
# * Update
#--------------------------------------------------------------------------
  def update()
    @config["img_sync"]  ? update_bg() : update_bg_s()
    #scroll_bg_x(@orig_bitmap)
    eb_wave(@orig_bitmap)
    #scroll_bg_y(self.bitmap)
    @config["anim_sync"] ? eb_anim()   : eb_anim_s()
    @time += 1
    @sync_time += 1
  end
#--------------------------------------------------------------------------
# * "Scroll" Background by splicing image
#--------------------------------------------------------------------------
  def scroll_bg_x(bitmap)
    return if @time % 2 != 0
    @orig_bitmap = Bitmap.new(bitmap.width, bitmap.height)
    @orig_bitmap.blt(2 - bitmap.width, 0, bitmap, bitmap.rect)
    @orig_bitmap.blt(2, 0, bitmap, bitmap.rect)
  end
#--------------------------------------------------------------------------
# * "Scroll" Background by splicing image
#--------------------------------------------------------------------------
  def scroll_bg_y(bitmap)
    @scroll_y += 2
    @scroll_y = @scroll_y % bitmap.height
    new_btmp = Bitmap.new(bitmap.width, bitmap.height)
    new_btmp.blt(0, @scroll_y - bitmap.height, bitmap, bitmap.rect)
    new_btmp.blt(0, @scroll_y, bitmap, bitmap.rect)
    self.bitmap = new_btmp
  end
#--------------------------------------------------------------------------
# * Basic Wave updating
#--------------------------------------------------------------------------
  def eb_wave(bitmap)
    time = 0
    line = 0
    new_bitmap = Bitmap.new(bitmap.width, bitmap.height)

    while line < bitmap.height do
      @offset = @config["amplitude"] *
       Math.sin(@config["frequency"] * line + @time * @config["time_scale"])
      new_x = 0
      new_y = line
      sorc_rect = Rect.new(0, line, bitmap.width, 2)
      case @config["type"]
        when 0
          new_x = @offset
          new_bitmap.blt(new_x, new_y, bitmap , sorc_rect)
        when 1
          new_x = (line / 2).even? ? @offset - 1: -@offset
          new_bitmap.blt(new_x, new_y, bitmap , sorc_rect)
        when 2
          old_time = @time - 1
          old_off = @config["amplitude"] *
           Math.sin(@config["frequency"] * line + old_time * @config["time_scale"])
          new_y = line * @config["compression"] + @offset
          rect = Rect.new(new_x, old_off + line * @config["compression"], bitmap.width, (old_off - new_y).abs)
          new_bitmap.stretch_blt(rect, bitmap , sorc_rect)
          if new_y > bitmap.height
            loc = new_y - bitmap.height
            new_bitmap.stretch_blt(Rect.new(0, 0, bitmap.width, loc), bitmap, sorc_rect)
          end
      end

      line += 2
    end
    self.bitmap = new_bitmap
  end
#--------------------------------------------------------------------------
# * Animation of elements
#--------------------------------------------------------------------------
  def eb_anim
    return if !@config["anim_basic"]
    case @config["anim_type"]
      when 0
        @val = @config["anim_str"] * Math.sin(@config["anim_spd"] * @time)
      when 1
        @anim_forward ? @val += @config["anim_spd"] : @val -= @config["anim_spd"]
        @anim_forward = true  if @val <= -@config["anim_str"]
        @anim_forward = false if @val >=  @config["anim_str"]
    end
      @val += @config["anim_str"] * 0.5 if @config["anim_pos"]
    case @config["anim_target"]
      when 0
        @config["amplitude"]  = @val
      when 1
        @config["frequency"]  = @val
      when 2
        @config["time_scale"] = @val
      when 3
        @config["scrl_y_spd"] = @val
    end
  end
#--------------------------------------------------------------------------
# * animation of elements SYNCED
#--------------------------------------------------------------------------
  def eb_anim_s
    return if !@config["anim_basic"]
    case @config["anim_type"]
      when 0
        @val = @config["anim_str"] * Math.sin(@config["anim_spd"] * @sync_time)
      when 1
        @anim_forward ? @val += @config["anim_spd"] : @val -= @config["anim_spd"]
        @anim_forward = true  if @val <= -@config["anim_str"]
        @anim_forward = false if @val >=  @config["anim_str"]
    end
      @val += @config["anim_str"] * 0.5 if @config["anim_pos"]
    case @config["anim_target"]
      when 0
        @config["amplitude"]  = @val
      when 1
        @config["frequency"]  = @val
      when 2
        @config["time_scale"] = @val
      when 3
        @config["scrl_y_spd"] = @val
    end
  end

  def update_bg()
    return if !@config["img_cycle"]

    if @time % @config["img_speed"] == 0
      @bg_count += 1
      @bg_count = 0 if @bg_count > @config["img_array"].count
    end

    case @bb_num
      when 1
        @orig_bitmap = Cache.battleback1(@config["img_array"])
      when 2
        @orig_bitmap = Cache.battleback2(@config["img_array"])
    end

  end

  def update_bg_s()
    return if !@config["img_cycle"]
    if @sync_time % @config["img_speed"] == 0
      @bg_count += 1
      @bg_count = 0 if @bg_count > @config["img_array"].count
    end

    case @bb_num
      when 1
        @orig_bitmap = Cache.battleback1(@config["img_array"])
      when 2
        @orig_bitmap = Cache.battleback2(@config["img_array"])
    end

  end

end #End Class Earthbound_Back
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
  # * Pull Settings for battleback 1 | new method
  #--------------------------------------------------------------------------
  def get_bb1_settings()
    if Tuckie_eb_bb_config::BACKGROUND_DEETS.has_key? battleback1_name
      default = Tuckie_eb_bb_config::BACKGROUND_DEETS["Default"]
      options = Tuckie_eb_bb_config::BACKGROUND_DEETS[battleback1_name]
      options = default.merge(options)
      return options
    else
      print("Default")
      return Tuckie_eb_bb_config::BACKGROUND_DEETS["Default"]
    end
  end
  #--------------------------------------------------------------------------
  # * Pull Settings for battleback 2 | new method
  #--------------------------------------------------------------------------
  def get_bb2_settings()
    if Tuckie_eb_bb_config::BACKGROUND_DEETS.has_key? battleback2_name
      default = Tuckie_eb_bb_config::BACKGROUND_DEETS["Default"]
      options = Tuckie_eb_bb_config::BACKGROUND_DEETS[battleback2_name]
      options = default.merge(options)
      return options
    else
      return Tuckie_eb_bb_config::BACKGROUND_DEETS["Default"]
    end
  end
  #--------------------------------------------------------------------------
  # * Create Battle Background (Floor) Sprite | overwrite
  #--------------------------------------------------------------------------
  def create_battleback1
    @back1_sprite = []
    setup = get_bb1_settings
      strip = Earthbound_Back.new(@viewport1)
      #set strip boys
      strip.config = setup
      strip.blend_type = setup["blend"]
      strip.bb_num = 1
      #get strip image
      strip.bitmap = battleback1_bitmap
      strip.z = 1
      strip.orig_bitmap = battleback1_bitmap
      center_sprite_x(strip)
      @back1_sprite.push(strip)
  end
  #--------------------------------------------------------------------------
  # * Create Battle Background (Wall) Sprite
  #--------------------------------------------------------------------------
  def create_battleback2
    @back2_sprite = []
    setup = get_bb2_settings
      strip = Earthbound_Back.new(@viewport1)
      #set strip boys
      strip.config = setup
      strip.blend_type = setup["blend"]
      strip.bb_num = 1
      #get strip image
      strip.bitmap = battleback2_bitmap
      strip.z = 2
      strip.orig_bitmap = battleback2_bitmap
      center_sprite_x(strip)
      @back2_sprite.push(strip)
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
    unless @back1_sprite.empty?
      @back1_sprite.each { |bb| bb.dispose() }
      @back1_sprite = []
    end
  end
  #--------------------------------------------------------------------------
  # * Free Battle Background (Wall) Sprite
  #--------------------------------------------------------------------------
  def dispose_battleback2
    unless @back2_sprite.empty?
      @back2_sprite.each { |bb| bb.dispose() }
      @back2_sprite = []
    end
  end
  #--------------------------------------------------------------------------
  # * Update Battle Background (Floor) Sprite
  #--------------------------------------------------------------------------
  def update_battleback1
    unless @back1_sprite.empty?
      @back1_sprite.each do |bb|
        bb.update()
      end
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
