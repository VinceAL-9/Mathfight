extends Control

@onready var transition = $Transition
@onready var v_box_container = $Background/VBoxContainer
@onready var button_sfx: AudioStreamPlayer = $Button_SFX
@onready var username_label: Label = $Header/Username 

#Gets the config file
var config := ConfigFile.new()
var FILE_PATH := "user://players.cfg"
var username: String = "" 
	
func _ready():# Load config file
	var err = config.load(FILE_PATH)
	if err != OK:
		print("Config file not found! Creating a new config file.")
		# If the file doesn't exist, create it
		config.save(FILE_PATH)
		return

	# Load the username from the config file
	username = load_user_profile()

	# Set the username on the label in the main menu
	if username != "":
		username_label.text =  username
	else:
		username_label.text = "Guest"  # Default to "Guest" if no user is found

	# Play transition animation
	$Options.visible = false
	$Transition/ColorRect.visible = true
	transition.play("fade_in")
	await get_tree().create_timer(1).timeout

# Function to load the user profile if no user found return empty str
func load_user_profile() -> String:
	if config.has_section_key("session", "last_user"):
		return config.get_value("session", "last_user")
	else:
		return ""


# Button press functions for different scenes
func _on_play_button_pressed() -> void:
	if button_sfx:
		button_sfx.play()
	transition.play("fade_out")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/Whole game/Choose mode/mode_select.tscn")
	print("Play button pressed")

func _on_store_button_pressed() -> void:
	if button_sfx:
		button_sfx.play()
	get_tree().change_scene_to_file("res://scenes/Whole game/placeholderscene.tscn")
	print("Store button pressed")

func _on_achievements_button_pressed() -> void:
	if button_sfx:
		button_sfx.play()
	get_tree().change_scene_to_file("res://scenes/Whole game/placeholderscene.tscn")
	print("Achievements button pressed")

func _on_equipment_button_pressed() -> void:
	if button_sfx:
		button_sfx.play()
	get_tree().change_scene_to_file("res://scenes/Whole game/placeholderscene.tscn")
	print("Equipment button pressed")

func _on_settings_button_pressed() -> void:
	if button_sfx:
		button_sfx.play()
	$Options.visible = not $Options.visible
	v_box_container.visible = not v_box_container.visible

func _on_check_button_toggled(toggled_on: bool) -> void:
	if button_sfx:
		button_sfx.play()
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_notifications_button_pressed() -> void:
	pass # Replace with function body.

func _on_tasks_button_pressed() -> void:
	pass # Replace with function body.

func linear_to_db(value: float) -> float:
	return 20.0 * log(value)

#Converts into Db and controls sound
func _on_h_slider_value_changed(value: float) -> void:
	var volume_db: float

	if value <= 0.0:
		volume_db = -80.0 
	else:
		volume_db = linear_to_db(value)

	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, volume_db)

func _on_resolution_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	
