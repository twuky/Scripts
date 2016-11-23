=begin

  Flavor Text in Battles
  Made By Tuckie (tucker.johnson.qcd@gmail.com)
  Date : 11 June 2016

  Version: Not Done

(imagine "-" hyphens)



  This script does cool stuff that makes games better.

________________________________________________________________________________
 Instructions ======================================================  _ [ ] [X]
|______________________________________________________________________________|

  Put this script somewhere between the "materials" item and the "Main" script.
  Mind the pit of snakes on B2F.

|______________________________________________________________________________|

________________________________________________________________________________
 Terms Of Use ======================================================  _ [ ] [X]
|______________________________________________________________________________|

  Feel free to use this script in commercial or free/donation based games.
  I luv u
  If you are making a for-profit game, though, it wouldn't hurt to send a key
  my way. ;()

|______________________________________________________________________________|

=end

module Tuckie_BattleFlavor
  # X and Y locations of displayed text, where (0,0) is the top right
  FLTEXT_X =  0
  FLTEXT_Y =  0

  #--------------------------------------------------------------------------
  # TEXT CUSTOMIZATION
  #   Each Entry into the array below represents the set of quotes for one
  #   troop.
  #   The first Entry are phrases that will display if you have not
  #   created an array for a troop yet. (i.e if the troop id is higher than
  #   the number of arrays you have set.
  #--------------------------------------------------------------------------

  ENEMY_FLAVOR =[

    ["It's Time To Slam Jam", "Watch Out For My Secret Move!"], # Default Phrases. Array index 0
    [nil],#troop 1
    [nil],#troop 2
    [],#troop 3
    ["It smells like robots.",
    "Tuckie is being ironic, and stuff.", "We're gonna need to replace the carpet."]#troop 4




  ]# End of flavors

end #Keep this here!! ;)

class Tuckie_Flavortext_get < Game_Troop

  def gettroopid
    @@FlavorTroop = $game_troop.troop.id  #.alive_members[@index]
    getflavstrings(@@FlavorTroop)
  end

  def getflavstrings(troop)
    if Tuckie_BattleFlavor::ENEMY_FLAVOR[troop] != nil
      @@FlavStrings = Tuckie_BattleFlavor::ENEMY_FLAVOR[troop]
      flavlength = @@FlavStrings.count
      #flavlength -= 1
      flavor = @@FlavStrings[rand(0 - flavlength)]
      return flavor
    else
      @@FlavStrings = Tuckie_BattleFlavor::ENEMY_FLAVOR[0]
      flavlength = @@FlavStrings.count
      #flavlength -= 1
      flavor = @@FlavStrings[rand(0 - flavlength)]
      return flavor
    end
  end

end





  #--------------------------------------------------------------------------
  # * Window that displays flavor text
  #--------------------------------------------------------------------------
class BattleFlavorWindow < Window_Base

    def initialize
      super(-6, -12, 648, 480)
      self.z = 299
      self.back_opacity = 0
    end

    def change_text (string = "No Text Detected")
      return unless string.is_a?(String)
      contents.clear
      draw_text( Tuckie_BattleFlavor::FLTEXT_X, Tuckie_BattleFlavor::FLTEXT_Y,
      640, 32, string, 0)
    end

    def draw_text(x, y, text_width, text_height, string, allignment = 0)
      contents.draw_text(x, y, text_width, text_height, string, allignment)
    end
    def destroy
      contents.clear
    end
end #class BattleFlavorWindow

  #--------------------------------------------------------------------------
  # * Create flavor text window on battle start
  #--------------------------------------------------------------------------
class Scene_Battle < Scene_Base

  def initialize()
  super
    @@window = BattleFlavorWindow.new
  end # initialize

    alias Tuckie_DrawFlavorWindow   start_party_command_selection
    def start_party_command_selection
      Tuckie_DrawFlavorWindow()
      @@window = BattleFlavorWindow.new
      tftget = Tuckie_Flavortext_get.new
      @@window.change_text(tftget.gettroopid)

    end # create_all_windows

    alias Tuckie_DelFlavorWindow turn_start
    def turn_start
      Tuckie_DelFlavorWindow()
        if @@window != nil
        @@window.dispose
        end
    end

    alias Tuckie_FlavorEscape command_escape
    def command_escape
        @@window.dispose
      Tuckie_FlavorEscape()
    end
end# class BattleFlavor
