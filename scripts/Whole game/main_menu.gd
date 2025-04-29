extends Control

@onready var transition = $Transition
@onready var v_box_container = $Background/VBoxContainer
@onready var button_sfx: AudioStreamPlayer = $Button_SFX

func _ready():
	$Options.visible = false
	transition.play("fade_in")
	await get_tree().create_timer(1).timeout

func _on_play_button_pressed() -> void:
	if button_sfx:
		button_sfx.play()
	transition.play("fade_out")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/Whole game/Choose mode/mode_select.tscn")
	print("button is pressed")


func _on_store_button_pressed() -> void:
	if button_sfx:
		button_sfx.play()
	get_tree().change_scene_to_file("res://scenes/Whole game/placeholderscene.tscn")
	print("store button is pressed")

func _on_achievements_button_pressed() -> void:
	if button_sfx:
		button_sfx.play()
	get_tree().change_scene_to_file("res://scenes/Whole game/placeholderscene.tscn")
	print("achievements button is pressed")

func _on_equipment_button_pressed() -> void:
	if button_sfx:
		button_sfx.play()
	get_tree().change_scene_to_file("res://scenes/Whole game/placeholderscene.tscn")
	print("equipment button is pressed")


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
