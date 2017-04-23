#==============================================================================
# ** Vocab
#------------------------------------------------------------------------------
#  This module defines terms and messages. It defines some data as constant
# variables. Terms in the database are obtained from $data_system.
#==============================================================================

module Vocab

  # Shop Screen
  ShopBuy         = "Buy"
  ShopSell        = "Sell"
  ShopCancel      = "Cancel"
  Possession      = "Possession"

  # Status Screen
  ExpTotal        = "Current Exp"
  ExpNext         = "To Next %s"

  # Save/Load Screen
  SaveMessage     = "Save to which file?"
  LoadMessage     = "Load which file?"
  File            = "File"

  # Display when there are multiple members
  PartyName       = "%s's Party"

  # Basic Battle Messages
  Emerge          = "%s is kickin' it!"
  Preemptive      = "%s snuck up on the enemies!"
  Surprise        = "%s fell prey to a sneak attack"
  EscapeStart     = "%s is making a break for it!"
  EscapeFailure   = "It didn't work!"

  # Battle Ending Messages
  Victory         = "%s was victorious!"
  Defeat          = "%s was defeated."
  ObtainExp       = "%s EXP received!"
  ObtainGold      = "%s\\G found!"
  ObtainItem      = "%s found!"
  LevelUp         = "%s is now %s %s!"
  ObtainSkill     = "%s learned!"

  # Use Item
  UseItem         = "%s uses %s!"

  # Critical Hit
  CriticalToEnemy = "An excellent hit!!"
  CriticalToActor = "A painful blow!!"

  # Results for Actions on Actors
  ActorDamage     = "%s took %s damage!"
  ActorRecovery   = "%s recovered %s %s!"
  ActorGain       = "%s gained %s %s!"
  ActorLoss       = "%s lost %s %s!"
  ActorDrain      = "%s was drained of %s %s!"
  ActorNoDamage   = "%s took no damage!"
  ActorNoHit      = "%s stepped out of the way."

  # Results for Actions on Enemies
  EnemyDamage     = "%s took %s damage!"
  EnemyRecovery   = "%s recovered %s %s!"
  EnemyGain       = "%s gained %s %s!"
  EnemyLoss       = "%s lost %s %s!"
  EnemyDrain      = "Drained %s %s from %s!"
  EnemyNoDamage   = "%s took no damage!"
  EnemyNoHit      = "Missed! %s took no damage!"

  # Evasion/Reflection
  Evasion         = "%s evaded the attack!"
  MagicEvasion    = "%s nullified the magic!"
  MagicReflection = "%s reflected the magic!"
  CounterAttack   = "%s counterattacked!"
  Substitute      = "%s protected %s!"

  # Buff/Debuff
  BuffAdd         = "%s's %s went up!"
  DebuffAdd       = "%s's %s went down!"
  BuffRemove      = "%s's %s returned to normal."

  # Skill or Item Had No Effect
  ActionFailure   = "There was no effect on %s!"

end
