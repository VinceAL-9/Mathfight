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

func _on_start_timer_timeout() -> void:
	interface.visible = false # Hide the label
	game_display.visible = true
	game.set_process(true)
