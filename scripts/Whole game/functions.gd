# a global script to make these functions accessible everywhere in the game
# these functions are loading screens with different background
extends Node

func load_screen_to_scene(target: String) -> void: # declaring function to make loading screen transition
	var loading_screen0 = preload("res://scenes/Whole game/loading_screen.tscn").instantiate() # asssigns a variable to a preloaded loading screen scene
	loading_screen0.next_scene_path = target # assigns the destination scene after the loading scene
	get_tree().current_scene.add_child(loading_screen0) # adds the loading scene to the current scene as a child

func load_screen_to_scene1(target: String) -> void:
	var loading_screen = preload("res://scenes/Whole game/loading_screen_1.tscn").instantiate()
	loading_screen.next_scene_path = target
	get_tree().current_scene.add_child(loading_screen)
	
func load_screen_to_scene2(target: String) -> void:
	var loading_screen1 = preload("res://scenes/Whole game/loading_screen_2.tscn").instantiate()
	loading_screen1.next_scene_path = target
	get_tree().current_scene.add_child(loading_screen1)
	
	
	
