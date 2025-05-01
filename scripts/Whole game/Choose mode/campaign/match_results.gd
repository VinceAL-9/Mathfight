extends Control

@onready var animated_sprite_2d = $CanvasLayer/AnimatedSprite2D

func _ready():
	animated_sprite_2d.play("idle")

func _on_back_button_pressed() -> void:
	pass


func _on_continue_button_pressed() -> void:
	Music.play_menu_music()
	Functions.load_screen_to_scene("res://scenes/Whole game/main_menu.tscn")
