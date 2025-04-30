extends Control

@onready var transition = $Transition2
@onready var button_sfx: AudioStreamPlayer = $Button_SFX

func _ready():
	transition.play("fade_in")
	await get_tree().create_timer(1).timeout
	
	
func _on_texture_button_pressed() -> void:
	if button_sfx:
		button_sfx.play()
	transition.play("fade_out")
	await get_tree().create_timer(1).timeout
	Functions.load_screen_to_scene1("res://scenes/Whole game/Choose mode/campaign/campaign_select.tscn")


func _on_button_pressed() -> void:
	transition.play("fade_out")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/Whole game/main_menu.tscn")
