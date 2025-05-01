extends Control

@onready var button_sfx: AudioStreamPlayer = $Button_SFX



func _on_button_button_down() -> void:
	if button_sfx:
		button_sfx.play()
	get_tree().change_scene_to_file("res://scenes/Whole game/menu_login.tscn")
