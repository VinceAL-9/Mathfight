extends Node2D

@onready var start_timer: Timer = $StartTimer
@onready var game: Node2D = $game
@onready var interface: CanvasLayer = $Interface
@onready var game_display: CanvasLayer = $game.get_node("Display")


func _ready() -> void:
	interface.visible = true # Show "Get ready…" message
	game_display.visible = false
	game.set_process(false) # Disable processing temporarily
	start_timer.start()


	# Set correct level generator based on global GameState
	match Gamestate.selected_level:
		1:
			game.level_generator = $ProbGenerators/Level_1Generator
			game.get_node("ProblemTimers/Timer for Solving").wait_time = 15
		2:
			game.level_generator = $ProbGenerators/Lvl2Generator
			game.get_node("ProblemTimers/Timer for Solving").wait_time = 25
		3:
			game.level_generator = $ProbGenerators/Lvl3Generator
			game.get_node("ProblemTimers/Timer for Solving").wait_time = 45
	# set position of problem display afterwards
	game.level_generator.position = Vector2(528, 134)


func _on_start_timer_timeout() -> void:
	interface.visible = false # Hide the label
	game_display.visible = true
	game.set_process(true)
