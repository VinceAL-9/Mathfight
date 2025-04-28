extends Control

@onready var transition1 = $Transition1

func _ready():
	transition1.play("fade_in")
	await get_tree().create_timer(0.8).timeout
	

func _on_back_button_pressed() -> void:
	print("button exit")

func _on_button_pressed() -> void:
	transition1.play("fade_out")
	await get_tree().create_timer(0.8).timeout
	Functions.load_screen_to_scene2("res://scenes/Whole game/placeholderscene.tscn")

func _on_button_2_pressed() -> void:
	transition1.play("fade_out")
	await get_tree().create_timer(0.8).timeout
	Functions.load_screen_to_scene2("res://scenes/Whole game/placeholderscene.tscn")

func _on_button_3_pressed() -> void:
	transition1.play("fade_out")
	await get_tree().create_timer(0.8).timeout
	Functions.load_screen_to_scene2("res://scenes/Whole game/placeholderscene.tscn")

func _on_button_4_pressed() -> void:
	transition1.play("fade_out")
	await get_tree().create_timer(0.8).timeout
	Functions.load_screen_to_scene2("res://scenes/Whole game/placeholderscene.tscn")

func _on_button_5_pressed() -> void:
	transition1.play("fade_out")
	await get_tree().create_timer(0.8).timeout
	Functions.load_screen_to_scene2("res://scenes/Whole game/placeholderscene.tscn")
