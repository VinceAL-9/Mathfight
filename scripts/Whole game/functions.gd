extends Node


func load_screen_to_scene1(target: String) -> void:
	var loading_screen = preload("res://scenes/loading_screen_1.tscn").instantiate()
	loading_screen.next_scene_path = target
	get_tree().current_scene.add_child(loading_screen)
	
func load_screen_to_scene2(target: String) -> void:
	var loading_screen1 = preload("res://scenes/loading_screen_2.tscn").instantiate()
	loading_screen1.next_scene_path = target
	get_tree().current_scene.add_child(loading_screen1)
	
	
	
