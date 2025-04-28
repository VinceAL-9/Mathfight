extends Control

@onready var transition = $Transition2

func _ready():
	transition.play("fade_in")
	await get_tree().create_timer(0.8).timeout
	
	
func _on_texture_button_pressed() -> void:
	transition.play("fade_out")
	await get_tree().create_timer(0.8).timeout
	Functions.load_screen_to_scene1("res://scenes/Whole game/Choose mode/campaign/campaign_select.tscn")
