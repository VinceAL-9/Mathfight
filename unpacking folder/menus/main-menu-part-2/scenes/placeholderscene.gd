extends Node2D

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_campaign_test_pressed() -> void:
	Functions.load_screen_to_scene1("res://scenes/campaign_select.tscn")
