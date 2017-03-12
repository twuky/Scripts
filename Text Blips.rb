=begin
    ______________________
  <  Advanced Text Blips  │
   │ By tuckie            │
   │                      │
   │ 12/14/16             │
   │ Version: Pretty Done │
   │______________________│

        ____________
 (-o-)< hi there!!! │
       │____________│

    __________________________________________
  <                                           │
   │ This script adds customizeable text sfx  │
   │ to your message windows. You can change  │
   │ settings on-the-fly using tagged         │
   │ commands.                                │
   │__________________________________________│

================================================================================
   HOW TO USE TEXT COMMANDS:

    \TVOL[X]
    X (0-100) changes the volume of the sound effect

    \TNAM[X]
    X represents which sound effect to switch to, as defined
    in the settings below

    \TMAX[X] and \TMIN[X]
    X is the maximum and minimum pitch of the sound effect. This is randomized,
    so if you want it to be the same each time, set both to be the same number.
    Keep TMAX higher than TMIN.

    \TCNT[X]
    X is how many letters are skipped before the sound plays again. Sometimes
    it can be too annoying to play the sound on every letter, so adjust this
    as is fitting.
================================================================================

=end


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#_______________________________________________________________________________
#
# SETTINGS
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
  COUNT = 4

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
  RANDOMNESS = 40

  #-----------------------------------------------------------------------------
  # Pitch Settings
  # Enter a Maximum and Minimum pitch, from 70 to 150
  #-----------------------------------------------------------------------------
  MAXIMUM = 170
  MINIMUM = 120

  #-----------------------------------------------------------------------------
  # Filename and Location Settings
  # Change SFX with a number, meaning in a message window:
  # /TNAM[0] will look for the first item,
  # /TNAM[1] will look for the second item,
  # /TNAM[2] will look for the third item, etc.
  #-----------------------------------------------------------------------------
  SE_NAME = [
    "vce TextBlip",           # \TNAM[0], This will be the DEFAULT sound.
    "vce bubble",             # \TNAM[1]
    "vce Metallic",           # \TNAM[2]
    "vce dark"                # \TNAM[3] ETC.
  ]

  #-----------------------------------------------------------------------------
  # Custom Text Commands
  # Here, you can create custom commands that link to specific sound effects.
  # Each entry is an array with the text in the command, and what SE_NAME number
  # (located above this) it links to.
  # DO NOT type the '\' in these settings. The script handles that automatically.
  # You still need to use a '\' in your messages.
  #-----------------------------------------------------------------------------
  CUSTOM_CMD = [
  ["TCST", 1],               # \TCST
  [],
  []
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
  attr_accessor :current_se   #
  #---------------------------#

  #-----------------------------------------------------------------------------
  # Initialize  | Alias
  #-----------------------------------------------------------------------------
  alias tuckie_textblips_initialize initialize
  def initialize(*args)
    @textblipvol  = SE_VOLUME
    @current_se   = 0
    @textblipmax  = MAXIMUM
    @textblipmin  = MINIMUM
    @count        = COUNT
    tuckie_textblips_initialize(*args)
  end

  #-----------------------------------------------------------------------------
  # Process if sound should play | New Method
  #-----------------------------------------------------------------------------
  def textblip(pitch)
    textblip_check_array()
    if RANDOMNESS == 0 or RANDOMNESS >= 100
      RPG::SE.new(@textblipfile, @textblipvol, pitch).play unless !BLIPS_ENABLED
    elsif rand(RANDOMNESS) <= RANDOMNESS
      RPG::SE.new(@textblipfile, @textblipvol, pitch).play unless !BLIPS_ENABLED
    end
  end
  #-----------------------------------------------------------------------------
  # Determin if current SFX is an array, and randomly pick sfx | New Method
  #-----------------------------------------------------------------------------
  def textblip_check_array()
    if SE_NAME[@current_se].is_a? Array
      @textblipfile = SE_NAME[@current_se].sample
    else
      @textblipfile = SE_NAME[@current_se]
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
    textblip_process(c) unless @show_fast
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
      @current_se = obtain_escape_param(text)
    when 'TMAX'
      @textblipmax = obtain_escape_param(text)
    when 'TMIN'
      @textblipmin = obtain_escape_param(text)
    when 'TCNT'
      @count = obtain_escape_param(text)
    end
    CUSTOM_CMD.each do |custom|
      if custom[0].is_a? String
       if custom[0].upcase == code.upcase
         @current_se = custom[1] if custom[1].is_a? Integer
       end
      end
    end
    tuckie_textblips_process_escape_character(code, text, pos)
  end
end
