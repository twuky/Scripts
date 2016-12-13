module Tuckie_textblips

  BLIPS_ENABLED = true

  #-----------------------------------------------------------------------------
  # Sound Effect DEFAULT settings. The game reverts to these settings each
  # time the game is launched, or when a setting has not been changed in-game.
  #
  #_____________________________________________________________________________
  # Count Settings
  # Define how many characters must be drawn before a sound is played.
  # Usually 3 or more sounds nice.
  #-----------------------------------------------------------------------------
  COUNT = 3

  #-----------------------------------------------------------------------------
  # Pitch Settings
  # Enter a Maximum and Minimum pitch, from 70 to 150
  #-----------------------------------------------------------------------------
  SKIP_SPACE = true

  #-----------------------------------------------------------------------------
  # Randomness Settings
  # The value of RANDOMNESS determines what chance it has to actually play
  # a sound. Enter a value out of 100, your percent chance the sound will play.
  # Entering 0 OR 100 will result in 100% chance of playing.
  #-----------------------------------------------------------------------------
  RANDOMNESS = 0

  #-----------------------------------------------------------------------------
  # Pitch Settings
  # Enter a Maximum and Minimum pitch, from 70 to 150
  #-----------------------------------------------------------------------------
  MAXIMUM = 170
  MINIMUM = 130

  #-----------------------------------------------------------------------------
  # Filename and Location Settings
  # Change SFX with a number, meaning in a message window:
  # /TNAM[1] will look for Knock1 etc.
  # Set it to 0 to use without a number. /TNAM[0] will look like Knock
  #-----------------------------------------------------------------------------
  SE_NAME = [
    "Blip",   # \TNAM[0]
    "Blop",   # \TNAM[1]
    "Blep",   # \TNAM[2]
    "Blap"   # \TNAM[3] ETC.
  ]

  #-----------------------------------------------------------------------------
  # Volume Settings
  #-----------------------------------------------------------------------------
  SE_VOLUME = 60

end

class Window_Message < Window_Base
  include Tuckie_textblips

  # Attribute Accessors ------#
  attr_accessor :textblipvol  #
  attr_accessor :textblipfile #
  attr_accessor :textblipmax  #
  attr_accessor :textblipmin  #
  attr_accessor :count        #
  #---------------------------#

  #-----------------------------------------------------------------------------
  # Initialize  | Alias
  #-----------------------------------------------------------------------------
  alias tuckie_textblips_initialize initialize
  def initialize(*args)
    @textblipvol  = SE_VOLUME
    @textblipfile = SE_NAME
    @textblipmax  = MAXIMUM
    @textblipmin  = MINIMUM
    @count        = COUNT
    tuckie_textblips_initialize(*args)
  end

  #-----------------------------------------------------------------------------
  # Process if sound should play | New Method
  #-----------------------------------------------------------------------------
  def textblip(pitch)
    if RANDOMNESS == 0 or RANDOMNESS >= 100
      RPG::SE.new(@textblipfile, @textblipvol, pitch).play unless !BLIPS_ENABLED
    elsif rand(RANDOMNESS) <= RANDOMNESS
      RPG::SE.new(@textblipfile, @textblipvol, pitch).play unless !BLIPS_ENABLED
    end
  end

  #-----------------------------------------------------------------------------
  # Process if sound should play | New Method
  #-----------------------------------------------------------------------------
  def textblip_process(c)
    pitch =MINIMUM + rand(MAXIMUM - MINIMUM)
    if SKIP_SPACE
      if c != " "
        if @count == COUNT
          textblip(pitch)
        end
      end
    else
      if @count == COUNT
        textblip(pitch)
      end
    end
    @count -= 1
    @count = COUNT if @count <= 0
  end

  #-----------------------------------------------------------------------------
  # Draw Character in text box | Alias
  #-----------------------------------------------------------------------------
  alias tuckie_textblips_process_character process_character
  def process_character(c, text, pos)
    textblip_process(c)
    tuckie_textblips_process_character(c, text, pos)
  end

  #--------------------------------------------------------------------------
  # Control Character Processing | Alias
  #--------------------------------------------------------------------------
  alias tuckie_textblips_process_escape_character process_escape_character
  def process_escape_character(code, text, pos)
    case code.upcase
    when 'TVOL'
      @textblipvol = obtain_escape_param(text)
    when 'TNAM'
      if obtain_escape_param(text) != 0
        @textblipfile = SE_NAME[obtain_escape_param(text)]
      else
        @textblipfile = SE_NAME[0]
      end
    when 'TMAX'
      @textblipmax = obtain_escape_param(text)
    when 'TMIN'
      @textblipmin = obtain_escape_param(text)
    when 'TCNT'
      @count = obtain_escape_param(text)
    end
    tuckie_textblips_process_escape_character(code, text, pos)
  end
end
