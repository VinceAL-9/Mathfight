extends Control

@onready var transition = $Transition

func _on_play_button_pressed() -> void:
	transition.play("fade_out")
	await get_tree().create_timer(0.8).timeout
	get_tree().change_scene_to_file("res://scenes/Whole game/Choose mode/mode_select.tscn")
	print("button is pressed")


func _on_store_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Whole game/placeholderscene.tscn")
	print("store button is pressed")

func _on_achievements_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Whole game/placeholderscene.tscn")
	print("achievements button is pressed")

func _on_equipment_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Whole game/placeholderscene.tscn")
	print("equipment button is pressed")


func _on_settings_button_pressed() -> void:
	pass # Replace with function body.


func _on_notifications_button_pressed() -> void:
	pass # Replace with function body.


func _on_tasks_button_pressed() -> void:
	pass # Replace with function body.
