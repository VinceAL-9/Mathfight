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
	time_elapsed.bbcode_text = str(fmod(Leveldata.time_elapsed, 3600) / 60).pad_decimals(0)  + ":" + str(fmod(Leveldata.time_elapsed, 60)).pad_decimals(0)
	items_solved.bbcode_text = Leveldata.items_solved
	items_not_solved.bbcode_text = Leveldata.items_not_solved
	Leveldata.time_elapsed = 0.0
	Leveldata.items_solved = 0
	Leveldata.items_not_solved = 0
	if Leveldata.level == 3:
		button_play.visible = false
	if !Leveldata.player_win:
		button_play.text = "Retry"
	

func _on_back_button_pressed() -> void:
	Music.play_menu_music()
	
	if Leveldata.player_win:
		if Leveldata.level == 1:
			if 2 not in Gamestate.unlocked_levels:
				Gamestate.unlocked_levels.append(2)
			Functions.load_screen_to_scene("res://scenes/Whole game/main_menu.tscn")
		elif Leveldata.level == 2:
				if 3 not in Gamestate.unlocked_levels:
					Gamestate.unlocked_levels.append(3)
				Functions.load_screen_to_scene("res://scenes/Whole game/main_menu.tscn")
		elif Leveldata.level == 3:
			Functions.load_screen_to_scene("res://scenes/Whole game/main_menu.tscn")
	else:
		Leveldata.level = 0
		Functions.load_screen_to_scene("res://scenes/Whole game/main_menu.tscn")

func _on_continue_button_pressed() -> void:
	Music.play_pregame()
	
	if Leveldata.player_win:
		if Leveldata.level == 1:
			if 2 not in Gamestate.unlocked_levels:
				Gamestate.unlocked_levels.append(2)
			Gamestate.selected_level = 2
			Functions.load_screen_to_scene("res://scenes/Whole game/Choose mode/campaign/levels/Pre-game2.tscn")
			Leveldata.level = 2

		elif Leveldata.level == 2:
			if 3 not in Gamestate.unlocked_levels:
				Gamestate.unlocked_levels.append(3)
			Gamestate.selected_level = 3
			Functions.load_screen_to_scene("res://scenes/Whole game/Choose mode/campaign/levels/Pre-game3.tscn")
			Leveldata.level = 3

		elif Leveldata.level == 3:
			Functions.load_screen_to_scene("res://scenes/Whole game/main_menu.tscn")
	else:
		if Leveldata.level == 1:
			Functions.load_screen_to_scene("res://scenes/Whole game/Choose mode/campaign/levels/level_1.tscn")
		elif Leveldata.level == 2:
			Functions.load_screen_to_scene("res://scenes/Whole game/Choose mode/campaign/levels/level_2.tscn")
		
		
