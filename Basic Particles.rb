
class Particle < Sprite
  #===============
  attr_accessor :start_size
  attr_accessor :size_speed
  #---
  attr_accessor :x_speed
  attr_accessor :y_speed
  attr_accessor :x_decay
  attr_accessor :y_decay
  #---
  attr_accessor :frame_limit
  #===============

  def initialize(img, loc_x, loc_y, loc_z)
    self.bitmap = Bitmap.new(Cache.system(img.to_s) )
    self.x = loc_x
    self.y = loc_y
    self.z = loc_z
    @frame_limit = -1
    @done = true
  end

  def set_size(s_start, s_end, s_speed)
    @start_size = s_start
    @size_speed = s_speed

  end

  def set_movement(x_speed, y_speed, x_decay, y_decay)
    @x_speed = x_speed
    @y_speed = y_speed
    @x_decay = x_decay
    @y_decay = y_decay

  end

  def update
    update_size()
    update_location()
    @frame_limit -= 1 if @frame_limit > 0
    determine_end()
  end

  def update_size()

  end

  def update_location()

  end

  def can_delete?
    return @done
  end

  def determine_if_done()
    if @frame_limit == 0
        @done = true
    end
  end

  def delete
    self.dispose
  end

end

class Game_Particles

  def initialize
    @particle_stack = []

  end

  def update
    @particle_stack.each do |particle|
      particle.update if particle <= Particle
    end
  end

end

class Game_Map
  attr_accessor :particles

  alias tuckie_particle_init initialize
  def initialize

    tuckie_particle_init
  end
end

class Game_Actor < Game_Battler

  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  alias tuckie_walkparticles_init initialize
  def initialize(*args)
    tuckie_walkparticles_init(*args)
  end
  #--------------------------------------------------------------------------
  # * Create Particle on step
  #--------------------------------------------------------------------------
  def create_walk_particle()

  end
  #--------------------------------------------------------------------------
  # * Processing Performed When Player Takes 1 Step
  #--------------------------------------------------------------------------
  alias tuckie_particle_walk on_player_walk
  def on_player_walk
    create_walk_particle()
    tuckie_particle_walk
  end

end

module DataManager

  class << self # or, class << MyModule
    alias tuckie_creategamepartics create_game_objects
    def create_game_objects()
      tuckie_creategamepartics()
      $game_particles = Game_Particles.new
    end
  end

end

module Graphics

  class << self
    alias tuckie_particle_update update
    def update()
    $game_particles.update
    tuckie_particle_update()
    end
  end

end
