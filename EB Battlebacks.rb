#    ______________________
#  <  EB Backgtounds       │
#   │ By tuckie            │
#   │                      │
#   │ 4/22/17              │
#   │ Version: eh% done    │
#   │______________________│

#        ____________
# (-o-)< hungry! !!  │
#       │____________│

#   __________________________________________
# <                                           │
#  │ This script changes battle backgrounds   │
#  │ to emulate the cool effects of the       │
#  │ backgrounds in famous SNES title         │
#  │ Earthbound. have fun lol :))))           │
#  │__________________________________________│

module Tuckie_eb_bb_config

  # Hey what's up dudes, it ur boy Tuckie 👌
  # Back at it again with scripting 🔥🔥🔥

  BACKGROUND_DEETS = {

    "Default" => {
      #== Basic Info ==#
        "amplitude"   => 30,
        "frequency"   => 2,
        "time_scale"  => 0.5,
        "compression" => 1,
      #== Type ==#
        #== 0 = sinewave, 1 = criss-cross, 2 = vertical stretch ==#
        "type"        => 0,
      #== vertical stretch settings, only used with "type" => 2, ==#
        "v_scale"     => 0.5,
        "v_zoom"      => 2,
      #== Y scrolling, images do loop. ==#
        "scrl_y_spd"  => 0,
      #== Image Cycling (for palette swap effect) ==#
        "img_cycle"   => false,
        #== Will look in Graphics/Battlebacks[1/2], whichever it is ==#
        "img_array"   => ["image_1", "image_2", "image_etc"],
        #== Background cycle updates every X frames ==#
        "img_speed"   => 16,
      #== Change basic element info to animate as a sinewave ==#
        "anim_basic"  => false,
        #== Changing frequency/time/amp over time looks cool ==#
          #== Amp. = 0, Freq. = 1, Time = 2 ==#
        "anim_target" => 0,
        #== Type of animation: sinewave = 0, linear = 1 ==#
        "anim_type"   => 0,
        #== The value the animation reaches to, positive and negative ==#
        "anim_str"    => 0,
        #== the speed the animation plays through ==#
        "anim_spd"    => 0.1,
    },

    #== Type your filename WITHOUT .png ==#
    #== Probably best to copy the default and modify it ==#
    "bg_img_2" => {

    }

  }

end

class Earthbound_Back < Sprite

  attr_accessor :time
  attr_accessor :count
  attr_accessor :offset
  attr_accessor :timer
  attr_accessor :orig_y
  attr_accessor :bb_num
  attr_accessor :config

  def initialize(*args)
    @val = 0 #variable to hold end value
    @anim_forward = true
    @timer = 1
    super(*args)
  end

  def update()
    @offset =  @config["amplitude"] *
      Math.sin(@config["frequency"] * @orig_y + @time * @config["time_scale"])
    tuckie_eb_update()
    @time += 1
  end

  def tuckie_eb_update()
    eb_wave()
    eb_cycle()
    eb_anim()
    eb_scroll_y()
    eb_placement()
  end

  def eb_wave()
    case @config["type"]
      when 0
        self.ox = @offset
        self.ox -= 1 if !self.ox.even?
      when 1
        self.ox = @count.even? ? @offset - 1: -@offset
        self.ox -= 1 if !self.ox.even?
      when 2
        newoff = @offset * @config["v_scale"]
        self.y = @orig_y * @config["compression"] + newoff
        self.y -= 1 if self.y.even?
        self.y -= 1 if self.y < 2
        self.ox = -1
        self.zoom_y = @config["v_zoom"]
    end
  end

  def eb_scroll_y
    @orig_y += @config["scrl_y_spd"]
  end

  def eb_cycle
    return if !@config["img_cycle"]
    @cycle_frame = 0 if !defined? @cycle_frame
    if @time % @config["img_speed"] == 0
      @cycle_frame += 1
      @cycle_frame = 0 if @cycle_frame > @config["img_array"].length
    end
    case bb_num
      when 1
        bitmap =  Bitmap.new(Cache.battleback1(@config["img_array"][@cycle_frame]))
        self.bitmap = bitmap
      when 2
        bitmap =  Bitmap.new(Cache.battleback2(@config["img_array"][@cycle_frame]))
        self.bitmap = bitmap
    end
  end

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

    case @config["anim_target"]
      when 0
        @config["amplitude"]  = @val
      when 1
        @config["frequency"]  = @val
      when 2
        @config["time_scale"] = @val
    end

  end

  def eb_placement
    self.y = (self.y + Graphics.height) % Graphics.height
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
  # * Pull Settings for battleback 1 | new method
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
    count = 0
    @back1_sprite = []
    setup = get_bb1_settings
    while count * 2 <= battleback1_bitmap.height - 2 do
      strip = Earthbound_Back.new(@viewport1)
      #set strip boys
      strip.config = setup
      strip.bb_num = 1
      strip.time = count
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
    setup = get_bb2_settings
    @back2_sprite = []
    while count * 2 <= battleback2_bitmap.height - 2 do
      strip = Earthbound_Back.new(@viewport1)
      #set strip boys
      strip.config = setup
      strip.bb_num = 2
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
