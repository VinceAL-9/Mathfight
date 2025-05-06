extends Control

@onready var button_sfx: AudioStreamPlayer = $Button_SFX
@onready var transition: AnimationPlayer = $CanvasLayer/Transition

func _ready():
	$CanvasLayer/Transition/ColorRect.visible = true # makes full black screen visible for the transition to play properly
	transition.play("fade_in") # does the transition
	await get_tree().create_timer(1).timeout # delay to accomodate
	


func _on_texture_button_pressed() -> void:
	if button_sfx: # plays sfx
		button_sfx.play()
	transition.play("fade_out") # transition
	Music.play_level_1() # music
	await get_tree().create_timer(1).timeout # delay
	get_tree().change_scene_to_file("res://scenes/Whole game/Choose mode/campaign/levels/level_1.tscn") # change scene
	Leveldata.level = 1 # sets the level in the leveldata global var
