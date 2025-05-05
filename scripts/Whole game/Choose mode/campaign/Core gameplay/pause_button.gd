extends TextureButton

@onready var PopupFade = $"../PausePopupFade" # variable that stores pause popup fade transition
@onready var Transition = $"../Transition" # variable that stores transition

func _ready():
	$"../PausePopupFade/PauseContainer".visible = false # makes that the pause pop up is not visible during start of the game 

func resume():
	get_tree().paused = false # pauses the game 
	if $"../..".has_method("resume_timer_with_adjustment"): # pauses the timer
		$"../..".resume_timer_with_adjustment()
	
func paused():
	get_tree().paused = true # resumes the game 
	if $"../..".has_method("store_timer_remaining"): # the timer gets unpaused
		$"../..".store_timer_remaining()
	
func _on_exit_button_pressed() -> void:
	resume() # resumes the game
	Leveldata.level = 0 # reset level data for the continue or retry button
	Transition.play("fade_out") # play transition
	Music.play_menu_music() # music
	await get_tree().create_timer(1).timeout # 1 second delay
	get_tree().change_scene_to_file("res://scenes/Whole game/Choose mode/campaign/campaign_select.tscn") # changes scene to campaign select

func _on_retry_button_pressed() -> void:
	if paused() == false: # checks if the game is paused 
		Transition.play("fade_out") # plays transition
		await get_tree().create_timer(1).timeout # delay for the transition
		get_tree().reload_current_scene() # reloads the current scene
	else: # if it is paused
		resume() # resume
		Transition.play("fade_out") # play transition
		await get_tree().create_timer(1).timeout # delay to make transition sync
		get_tree().reload_current_scene() # reloads the current scene

func _on_continue_button_pressed() -> void:
	resume() # resumes the game 
	PopupFade.play("fade_out") # the pause pop up menu fades out 
	await get_tree().create_timer(0.3).timeout # a small delay to account for transition
	$"../PausePopupFade/PauseContainer".visible = false # sets the visibility of the menu to false
	

func _on_pressed() -> void:
	$"../PausePopupFade/PauseContainer".visible = true # makes the pause menu visible
	PopupFade.play("fade_in") # plays transition
	paused() # pauses the game 

func _on_display_mode_option_item_selected(index: int) -> void: # function that adjusts the display mode of the game 
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func linear_to_db(value: float) -> float: # function that adjusts the volume of the game
	return 20.0 * log(value)
	
func _on_volume_slider_value_changed(value: float) -> void:
	var volume_db: float

	if value <= 0.0:
		volume_db = -80.0 
	else:
		volume_db = linear_to_db(value)

	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, volume_db)
