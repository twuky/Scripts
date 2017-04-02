
class Particle < Sprite
  #===============
  attr_accessor :start_size
  attr_accessor :end_size
  attr_accessor :size_speed
  #===============

  def initialize(img, loc_x, loc_y, loc_z)
    self.bitmap = Bitmap.new(Cache.system(img.to_s) )
    self.x = loc_x
    self.y = loc_y
    self.z = loc_z

  end

  def set_size(s_start, s_end, s_speed)
    @start_size = s_start
    @end_size = s_end
    @size_speed = s_speed


  end

  def update
    update_size()
    update_location()
    determine_end()
  end

  def update_size()

  end

  def update_location()

  end

  def determine_if_done()

  end

  def delete

  end
  
end

class Game_Particles
  def initialize
  end

  def update
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
