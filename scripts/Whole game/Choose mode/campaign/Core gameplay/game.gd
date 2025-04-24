extends Node2D

var player_health: int = 100
var enemy_health: int = 100

var rng := RandomNumberGenerator.new() # randomizer

@onready var anim: AnimationPlayer = $"Player and Enemy".get_node("AnimationPlayer") # animation player for the animations
@onready var prob_timer = $"ProblemTimers/Generate Problem" # time before generating next problem (initial: 3 secs, succeeding: 2-4 secs)
@onready var solve_timer = $"ProblemTimers/Timer for Solving" # time the player has to solve a problem

@onready var player_hp: Label = $Display/MarginContainer/PlayerHP
@onready var enemy_hp: Label = $Display/MarginContainer2/EnemyHP

# AnimatedSprite2d Nodes of player and enemy
@onready var player_sprite: AnimatedSprite2D = $"Player and Enemy".get_node("Player")
@onready var enemy_sprite: AnimatedSprite2D = $"Player and Enemy".get_node("Enemy")

var problem_active: bool # This is a placeholder for the problem generator
var problem_start_time: int
var game_over: bool = false # indicator whether this game is over
var has_answered: bool = false # prevents input spamming

func _ready() -> void: # executes once, at the start of the match
	# set positions of the player and enemy sprites
	player_sprite.position = Vector2(169, 280) 
	enemy_sprite.position = Vector2(946, 259)
	
	update_health_ui() # sets initial health display
	
	problem_active = false
	prob_timer.start()

func update_health_ui() -> void:
	player_hp.text = str(player_health)
	enemy_hp.text = str(enemy_health)

func _on_generate_problem_timeout() -> void:
	problem_active = true # generate a problem here then start the solve timer
	has_answered = false # allow answering again for the new problem
	solve_timer.start()
	problem_start_time = Time.get_ticks_msec() # gets the time at which the solve timer started and the problem generated

func _on_timer_for_solving_timeout() -> void:
	if problem_active and not has_answered: # prevent double triggers if answer was already given
		anim.play("enemy_attack") # play the animation with a bit of delay to sync with damage
		await get_tree().create_timer(1.3).timeout
		
		player_health -= 10
		update_health_ui()
		
		if player_health <= 0:
			anim.play("player_death") # death animation for player
			end_game()
			return
			
		problem_active = false
		prob_timer.start(rng.randi_range(2, 4))

func _process(_delta: float) -> void:
	if game_over: return # skip logic if game is over
	
	if problem_active and not has_answered and Input.is_action_just_pressed("ans"): # prevent spamming
		has_answered = true # lock in answer to prevent re-pressing
		
		# this gets the elapsed time since the start of the solve timer by subtracting the start time from current time
		var elapsed_time = (Time.get_ticks_msec() - problem_start_time) / 1000.0 # convert to seconds, since this is in milliseconds
		
		anim.play("player_attack") # play the animation with a bit of delay to sync with damage
		await get_tree().create_timer(1.0).timeout
		
		if elapsed_time <= 3.0: # if player solves in under 3 secs, crit damage
			enemy_health -= rng.randi_range(15, 20)
		else: # normal damage
			enemy_health -= 10
		
		update_health_ui()
		
		if enemy_health <= 0:
			anim.play("enemy_death") # death animation for enemy
			end_game()
			return
		
		solve_timer.stop() # stop the solve timer and start generate_problem timer
		prob_timer.start(rng.randi_range(2, 4))
		problem_active = false

func end_game() -> void:
	game_over = true # mark game as over
	solve_timer.stop() # stop timers to avoid further input or problems
	prob_timer.stop()
	print("Game Over") # can be replaced with a UI popup or scene transition
		
		
		
