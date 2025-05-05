extends Control

@onready var animated_sprite_2d = $CanvasLayer/AnimatedSprite2D
@onready var transition = $CanvasLayer/Transition
@onready var time_elapsed = $CanvasLayer/TimeElapsed
@onready var items_solved = $CanvasLayer/ItemsSolved
@onready var items_not_solved = $CanvasLayer/ItemsNotSolved
@onready var button_play = $CanvasLayer/ContinueButton

func _ready():
	transition.play("fade_in")
	animated_sprite_2d.play("idle")
	# statistics of the match results gotten from the level data global script
	time_elapsed.bbcode_text = str(fmod(Leveldata.time_elapsed, 3600) / 60).pad_decimals(0)  + ":" + str(fmod(Leveldata.time_elapsed, 60)).pad_decimals(0)
	items_solved.bbcode_text = Leveldata.items_solved
	items_not_solved.bbcode_text = Leveldata.items_not_solved
	# resets the data in the level data global script
	Leveldata.time_elapsed = 0.0
	Leveldata.items_solved = 0
	Leveldata.items_not_solved = 0
	if Leveldata.level == 3 and Leveldata.player_win: # if level is level 3 and has won, disable button
		button_play.visible = false
	if !Leveldata.player_win: # if player loses, the button text is retry instead of continue
		button_play.text = "Retry"
	

func _on_back_button_pressed() -> void: # back to main menu button
	Music.play_menu_music()
	
	if Leveldata.player_win: # checks if player has won
		if Leveldata.level == 1: # checks what level 
			if 2 not in Gamestate.unlocked_levels: # checks if next level is in the levels unlocked
				Gamestate.unlocked_levels.append(2) # adds the level to the levels unlocked
			Functions.load_screen_to_scene("res://scenes/Whole game/main_menu.tscn") # back to main menu
		elif Leveldata.level == 2:
				if 3 not in Gamestate.unlocked_levels:
					Gamestate.unlocked_levels.append(3)
				Functions.load_screen_to_scene("res://scenes/Whole game/main_menu.tscn")
		elif Leveldata.level == 3:
			Functions.load_screen_to_scene("res://scenes/Whole game/main_menu.tscn")
	else:
		Leveldata.level = 0
		Functions.load_screen_to_scene("res://scenes/Whole game/main_menu.tscn")

func _on_continue_button_pressed() -> void: # continue
	
	
	if Leveldata.player_win: # checks if player has won
		Music.play_pregame()
		if Leveldata.level == 1: # checks what level
			if 2 not in Gamestate.unlocked_levels: # checks if next level is in the levels unlocked  
				Gamestate.unlocked_levels.append(2) # adds the level to the levels unlocked
			Gamestate.selected_level = 2 # changes selected level
			Functions.load_screen_to_scene("res://scenes/Whole game/Choose mode/campaign/levels/Pre-game2.tscn") # changes scene to pregame 2
			Leveldata.level = 2 # sets level in level data to 2

		elif Leveldata.level == 2:
			if 3 not in Gamestate.unlocked_levels:
				Gamestate.unlocked_levels.append(3)
			Gamestate.selected_level = 3
			Functions.load_screen_to_scene("res://scenes/Whole game/Choose mode/campaign/levels/Pre-game3.tscn")
			Leveldata.level = 3

		elif Leveldata.level == 3:
			Functions.load_screen_to_scene("res://scenes/Whole game/main_menu.tscn")
	else: # for retry
		if Leveldata.level == 1:
			Music.play_level_1()
			Functions.load_screen_to_scene("res://scenes/Whole game/Choose mode/campaign/levels/level_1.tscn")
		elif Leveldata.level == 2:
			Music.play_level_2()
			Functions.load_screen_to_scene("res://scenes/Whole game/Choose mode/campaign/levels/level_2.tscn")
		elif Leveldata.level == 3:
			Music.play_level_3()
			Functions.load_screen_to_scene("res://scenes/Whole game/Choose mode/campaign/levels/level_3.tscn")
		
	
