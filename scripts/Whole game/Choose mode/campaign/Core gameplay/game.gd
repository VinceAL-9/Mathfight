extends Node2D

# HP values for player and enemy
var player_health: int = 100
var enemy_health: int = 100

var rng := RandomNumberGenerator.new() # randomizer for use 

# Reference to the AnimationPlayer that controls player and enemy animations
@onready var anim: AnimationPlayer = $"Player and Enemy".get_node("AnimationPlayer")

# Timers for generating math problems and solving them
@onready var prob_timer = $"ProblemTimers/Generate Problem"
@onready var solve_timer = $"ProblemTimers/Timer for Solving"

# UI Layer and HP bars
@onready var display: CanvasLayer = $Display
@onready var player_hp: ProgressBar = $Display/PlayerContainer/PlayerHpBar
@onready var enemy_hp: ProgressBar = $Display/EnemyContainer/EnemyHPBar

# Label that shows the countdown for solving a problem
@onready var solve_timer_display: Label = $Display/SolveTimerContainer/SolveTimerDisplay

# Transition animation for fading in and out
@onready var transition: AnimationPlayer = $Display/Transition

# Will point to the currently used level's math generator
var level_generator: Control

# Player and enemy sprite references
@onready var player_sprite: AnimatedSprite2D = $"Player and Enemy".get_node("Player")
@onready var enemy_sprite: AnimatedSprite2D = $"Player and Enemy".get_node("Enemy")

# On-screen keyboard for answering
@onready var keyboard: Control = $Display/Keyboard

# Sound that plays on wrong answers
@onready var wrong: AudioStreamPlayer = $Wrong

# Flags and state variables
var problem_active: bool # whether or not there is a problem currently generated
var problem_start_time: int # for tracking elapsed time
var game_over: bool = false # indicator whether this game is over
var has_answered: bool = false # prevents input spamming
var solve_timer_end_time: int # for displaying the solve timer every time a problem is generated
var solve_timer_remaining: float = 0.0 # for the pause button to sync with solve timer
var resume_allowed: bool = false # used for pause/resume functionality

func _ready() -> void: # executes once, at the start of the match
	# Set the solve timer duration based on level
	match Gamestate.selected_level:
		1:
			solve_timer.wait_time = 20
		2: 
			solve_timer.wait_time = 45
		3:
			solve_timer.wait_time = 40
	
	update_health_ui() # sets initial health display
	
	transition.play("fade_in") # fade into the game screen
	problem_active = false
	prob_timer.start() # begin countdown to first problem generation

# Updates the HP bar values to reflect current health
func update_health_ui() -> void:
	player_hp.value = player_health
	enemy_hp.value = enemy_health

# Called when it's time to generate a new math problem
func _on_generate_problem_timeout() -> void:
	problem_active = true
	resume_allowed = true
	
	# Set solve time depending on current level
	match Gamestate.selected_level:
		1:
			solve_timer.wait_time = 20
		2: 
			solve_timer.wait_time = 45
		3:
			solve_timer.wait_time = 40
	
	level_generator.generate_problem() # create a new math problem
	print(level_generator.get_current_answer())
	level_generator.get_node("ProblemLabel").visible = true # show the problem text
	has_answered = false
	solve_timer.start()
	
	# Calculate when the solve timer is expected to end
	solve_timer_end_time = Time.get_ticks_msec() + int(solve_timer.wait_time * 1000)
	solve_timer_display.visible = true
	
	problem_start_time = Time.get_ticks_msec() # record time when problem starts

# Stores the remaining time on the solve timer for pause/resume functionality
func store_timer_remaining():
	if not resume_allowed:
		return
	if solve_timer.is_stopped() == false:
		solve_timer_remaining = (solve_timer_end_time - Time.get_ticks_msec()) / 1000.0

# Resumes the solve timer based on previously stored time (after pause)
func resume_timer_with_adjustment():
	if resume_allowed and solve_timer_remaining > 0.0:
		solve_timer.start(solve_timer_remaining)
		solve_timer_end_time = Time.get_ticks_msec() + int(solve_timer_remaining * 1000)
		solve_timer_remaining = 0.0 # Clear ONLY after using

# Called when the player runs out of time to answer a problem
func _on_timer_for_solving_timeout() -> void:
	if problem_active and not has_answered:
		keyboard.reset_input() # clear input field
		
		solve_timer_display.visible = false
		level_generator.get_node("ProblemLabel").visible = false
		
		anim.play("enemy_attack")
		await get_tree().create_timer(1.5).timeout
		
		player_health -= rng.randi_range(15, 20) # player takes damage
		
		Leveldata.items_not_solved += 1
		update_health_ui()
		
		# Check if player is dead
		if player_health <= 0:
			anim.play("player_death")
			enemy_sprite.play("idle")
			Leveldata.player_win = false
			await end_game_after_delay()
			return
			
		problem_active = false
		resume_allowed = false
		prob_timer.start(rng.randi_range(2, 4)) # random wait before next problem
		has_answered = false

# Called when player submits an answer via the keyboard
func _on_keyboard_answer_submitted(answer_text: String) -> void:
	var current_ans = level_generator.get_current_answer()
	if game_over: return
	if not problem_active or has_answered: return
	
	has_answered = true # lock in the answer to prevent double inputs
	
	if answer_text == current_ans: # correct answer
		solve_timer_display.visible = false
		level_generator.get_node("ProblemLabel").visible = false
		
		# Calculate how quickly the answer was submitted
		var elapsed_time = (Time.get_ticks_msec() - problem_start_time) / 1000.0
		
		anim.play("player_attack")
		await get_tree().create_timer(1.0).timeout
		
		# Damage depends on how fast the player answers
		var total_time = solve_timer.wait_time
		var damage: int

		if elapsed_time <= total_time * 0.30:
			damage = 20
		elif elapsed_time > total_time * 0.75:
			damage = 10
		else:
			damage = 15

		enemy_health -= damage
		
		Leveldata.items_solved += 1
		update_health_ui()
		
		# Check if enemy is dead
		if enemy_health <= 0:
			anim.play("enemy_death")
			player_sprite.play("idle")
			Leveldata.player_win = true
			
			await end_game_after_delay()
			return
		
		solve_timer.stop()
		prob_timer.start(rng.randi_range(2, 4)) # wait before next problem
		problem_active = false
		resume_allowed = false
	
	else:
		# WRONG answer
		if wrong:
			wrong.play()
		keyboard.reset_input()
		has_answered = false

# Runs every frame
func _process(_delta: float) -> void:
	if game_over: return
	
	# Secret debug command to force enemy death
	if Input.is_action_just_pressed("autokill"):
		enemy_health -= 100
		if enemy_health <= 0:
			anim.play("enemy_death")
			player_sprite.play("idle")
			Leveldata.player_win = true
			
			await end_game_after_delay()
			return
	
	# Update the timer display while solving
	if solve_timer.is_stopped():
		solve_timer_display.visible = false
	else:
		var time_left = (solve_timer_end_time - Time.get_ticks_msec()) / 1000.0
		time_left = max(time_left, 0)
		solve_timer_display.text = str("%.1f" % time_left)
		
		# Color warning for low time
		if time_left <= 7.0:
			solve_timer_display.add_theme_color_override("font_color", Color.RED)
		else:
			solve_timer_display.add_theme_color_override("font_color", Color.YELLOW)
			
	Leveldata.time_elapsed += _delta

# Triggered at the end of the game
func end_game_after_delay() -> void:
	game_over = true
	
	solve_timer.stop()
	prob_timer.stop()
	display.queue_free() # remove all UI
	
	await get_tree().create_timer(4.0).timeout
	
	Music.play_match_results()
	Functions.load_screen_to_scene("res://scenes/Whole game/Choose mode/campaign/Core gameplay/Match Result/match_results.tscn")

		
		
		
