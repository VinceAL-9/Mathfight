extends Node

# stays loaded throughout the entire game, so both core gameplay scene and campaign select have access 
# to it; campaign select scene modifies the value and core gameplay acts on that value
var selected_level: int = 1

var unlocked_levels: Array = [1]  # Levels 2 and 3 will be added as the player wins
