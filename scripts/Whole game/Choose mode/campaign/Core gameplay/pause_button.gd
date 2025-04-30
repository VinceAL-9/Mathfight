extends TextureButton

@onready var PopupFade = $"../PausePopupFade"

func _ready():
	$"../PausePopupFade/PauseContainer".visible = false

func resume():
	get_tree().paused = false
	
func paused():
	get_tree().paused = true

func _on_exit_button_pressed() -> void:
	resume()
	get_tree().change_scene_to_file("res://scenes/Whole game/Choose mode/campaign/campaign_select.tscn")

func _on_retry_button_pressed() -> void:
	if paused() == false:
		get_tree().reload_current_scene()
	else:
		resume()
		get_tree().reload_current_scene()

func _on_continue_button_pressed() -> void:
	PopupFade.play("fade_out")
	$"../PausePopupFade/PauseContainer".visible = false
	resume()

func _on_pressed() -> void:
	$"../PausePopupFade/PauseContainer".visible = true
	PopupFade.play("fade_in")
	paused()

func _on_display_mode_option_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func linear_to_db(value: float) -> float:
	return 20.0 * log(value)
	
func _on_volume_slider_value_changed(value: float) -> void:
	var volume_db: float

	if value <= 0.0:
		volume_db = -80.0 
	else:
		volume_db = linear_to_db(value)

	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, volume_db)
