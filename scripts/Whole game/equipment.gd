extends Control

@onready var transition = $Background/Transition
@onready var button_sfx: AudioStreamPlayer = $Button_SFX

func _ready():
	$Background/Transition/ColorRect.visible = true
	transition.play("fade_in")
	await get_tree().create_timer(1).timeout

func _on_button_pressed() -> void:
	if button_sfx:
		button_sfx.play()
	transition.play("fade_out")
	await get_tree().create_timer(1).timeout
	Functions.load_screen_to_scene1("res://scenes/Whole game/main_menu.tscn")
