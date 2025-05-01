extends Node

var rng := RandomNumberGenerator.new()
@onready var main_menu_1: AudioStreamPlayer = $MainMenu1
@onready var main_menu_2: AudioStreamPlayer = $MainMenu2
@onready var main_menu_3: AudioStreamPlayer = $MainMenu3
@onready var pregame: AudioStreamPlayer = $Pregame
@onready var level_1: AudioStreamPlayer = $Level1
@onready var level_2: AudioStreamPlayer = $Level2
@onready var level_3: AudioStreamPlayer = $Level3
@onready var match_results: AudioStreamPlayer = $MatchResults
var current_music: AudioStreamPlayer

func _ready() -> void:
	current_music = main_menu_1
	if not main_menu_1.playing:
		main_menu_1.play()
		
func _on_main_menu_1_finished() -> void:
	await get_tree().create_timer(2.0).timeout
	main_menu_1.play()
	current_music = main_menu_1
	
	
func play_pregame() -> void:
	current_music.stop()
	await get_tree().create_timer(2.0).timeout
	pregame.play()
	current_music = pregame

func play_level_1() -> void:
	current_music.stop()
	await get_tree().create_timer(1.5).timeout
	level_1.play()
	current_music = level_1

func play_level_2() -> void:
	current_music.stop()
	await get_tree().create_timer(1.5).timeout
	level_2.play()
	current_music = level_2
	
func play_level_3() -> void:
	current_music.stop()
	await get_tree().create_timer(1.5).timeout
	level_3.play()
	current_music = level_3

func play_menu_music() -> void:
	current_music.stop()
	await get_tree().create_timer(2.0).timeout
	main_menu_1.play()
	current_music = main_menu_1

func play_match_results() -> void:
	current_music.stop()
	await get_tree().create_timer(1.5).timeout
	match_results.play()
	current_music = match_results


func _on_level_1_finished() -> void:
	await get_tree().create_timer(1.0).timeout
	level_1.play()

func _on_level_2_finished() -> void:
	await get_tree().create_timer(1.0).timeout
	level_2.play()

func _on_level_3_finished() -> void:
	await get_tree().create_timer(1.0).timeout
	level_3.play()
