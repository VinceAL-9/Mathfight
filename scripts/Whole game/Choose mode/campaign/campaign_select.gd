extends Control

@onready var transition1 = $Transition1
@onready var button_sfx: AudioStreamPlayer = $Button_SFX

@onready var button_2: Button = $Background/Button2
@onready var button_3: Button = $Background/Button3



func _ready():
	transition1.play("fade_in")
	
	# Disable buttons by default
	button_2.disabled = true
	button_3.disabled = true

	# Enable buttons based on unlocked levels
	if 2 in Gamestate.unlocked_levels:
		button_2.disabled = false
	if 3 in Gamestate.unlocked_levels:
		button_3.disabled = false
	
	await get_tree().create_timer(1).timeout
	



func _on_back_button_pressed() -> void: # returns to mode select
	if button_sfx:
		button_sfx.play()
	Functions.load_screen_to_scene2("res://scenes/Whole game/Choose mode/mode_select.tscn")

func _on_button_pressed() -> void: # the level 1 button
	Gamestate.selected_level = 1 # makes the gamestate level 1 which affects the problem generator and timer
	Music.play_pregame() # music
	if button_sfx:
		button_sfx.play()
	transition1.play("fade_out")
	await get_tree().create_timer(1).timeout
	Functions.load_screen_to_scene2("res://scenes/Whole game/Choose mode/campaign/levels/Pre-game1.tscn") # change scene to pre game 1

func _on_button_2_pressed() -> void:
	Gamestate.selected_level = 2
	Music.play_pregame()
	if button_sfx:
		button_sfx.play()
	transition1.play("fade_out")
	await get_tree().create_timer(1).timeout
	Functions.load_screen_to_scene2("res://scenes/Whole game/Choose mode/campaign/levels/Pre-game2.tscn")

func _on_button_3_pressed() -> void:
	Gamestate.selected_level = 3
	Music.play_pregame()
	if button_sfx:
		button_sfx.play()
	transition1.play("fade_out")
	await get_tree().create_timer(1).timeout
	Functions.load_screen_to_scene2("res://scenes/Whole game/Choose mode/campaign/levels/Pre-game3.tscn")
