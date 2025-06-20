extends Control

@onready var button_sfx: AudioStreamPlayer = $Button_SFX
@onready var transition: AnimationPlayer = $CanvasLayer/Transition

func _ready():
	$CanvasLayer/Transition/ColorRect.visible = true
	transition.play("fade_in")
	await get_tree().create_timer(1).timeout

func _on_texture_button_pressed() -> void:
	if button_sfx:
		button_sfx.play()
	transition.play("fade_out")
	Music.play_level_2()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/Whole game/Choose mode/campaign/levels/level_2.tscn")
	Leveldata.level = 2
