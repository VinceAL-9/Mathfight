extends Control

func _ready():
	$CanvasLayer/AnimatedSprite2D.play("idle")
func _on_back_button_pressed() -> void:
	Functions.load_screen_to_scene("res://scenes/Whole game/main_menu.tscn")


func _on_continue_button_pressed() -> void:
	pass # Replace with function body.
