extends Node2D

var player_health: int = 100
var enemy_health: int = 100

var rng := RandomNumberGenerator.new() # randomizer

@onready var anim: AnimationPlayer = $"Player and Enemy".get_node("AnimationPlayer") # animation player for the animations
@onready var prob_timer = $"ProblemTimers/Generate Problem" # time before generating next problem (initial: 6.5 secs (counting the start delay), succeeding: 2-4 secs)
@onready var solve_timer = $"ProblemTimers/Timer for Solving" # time the player has to solve a problem

@onready var display: CanvasLayer = $Display
@onready var player_hp: ProgressBar = $Display/PlayerContainer/PlayerHpBar
@onready var enemy_hp: ProgressBar = $Display/EnemyContainer/EnemyHPBar
@onready var solve_timer_display: Label = $Display/SolveTimerContainer/SolveTimerDisplay

@onready var transition: AnimationPlayer = $Display/Transition
# set the type of problem generator to be used in a specific level
var level_generator: Control


# AnimatedSprite2d Nodes of player and enemy
@onready var player_sprite: AnimatedSprite2D = $"Player and Enemy".get_node("Player")
@onready var enemy_sprite: AnimatedSprite2D = $"Player and Enemy".get_node("Enemy")

# Reference to the Keyboard
@onready var keyboard: Control = $Display/Keyboard

# Audio for wrong answer
@onready var wrong: AudioStreamPlayer = $Wrong


var problem_active: bool
var problem_start_time: int # for tracking elapsed time
var game_over: bool = false # indicator whether this game is over
var has_answered: bool = false # prevents input spamming
var solve_timer_end_time: int # for displaying the solve timer every time a problem is generated
var solve_timer_remaining: float = 0.0 # for the pause button to sync with solve timerr
var resume_allowed: bool = false

func _ready() -> void: # executes once, at the start of the match
	match Gamestate.selected_level: # manually set all wait times of solve timer upon generating a new problem
		1:
			solve_timer.wait_time = 20
		2: 
			solve_timer.wait_time = 45
		3:
			solve_timer.wait_time = 40
	
	update_health_ui() # sets initial health display
	
	transition.play("fade_in")
	problem_active = false
	prob_timer.start()
	

func update_health_ui() -> void:
	player_hp.value = player_health
	enemy_hp.value = enemy_health

func _on_generate_problem_timeout() -> void:
	problem_active = true # generate a problem here then start the solve timer
	resume_allowed = true
	
	match Gamestate.selected_level: # manually set all wait times of solve timer upon generating a new problem
		1:
			solve_timer.wait_time = 20
		2: 
			solve_timer.wait_time = 45
		3:
			solve_timer.wait_time = 40
	
	level_generator.generate_problem()
	print(level_generator.get_current_answer())
	level_generator.get_node("ProblemLabel").visible = true # display problem and generate it 
	has_answered = false # allow answering again for the new problem
	solve_timer.start()
	
	# Set when the timer is expected to end
	solve_timer_end_time = Time.get_ticks_msec() + int(solve_timer.wait_time * 1000)
	solve_timer_display.visible = true
	
	problem_start_time = Time.get_ticks_msec() # gets the time at which the solve timer started and the problem generated

func store_timer_remaining():
	if not resume_allowed:
		return
	if solve_timer.is_stopped() == false:
		solve_timer_remaining = (solve_timer_end_time - Time.get_ticks_msec()) / 1000.0

func resume_timer_with_adjustment(): # sync the solve timer with the display upon resuming from pause 
	if resume_allowed and solve_timer_remaining > 0.0:
		solve_timer.start(solve_timer_remaining)
		solve_timer_end_time = Time.get_ticks_msec() + int(solve_timer_remaining * 1000)
		solve_timer_remaining = 0.0 # Clear ONLY after using

func _on_timer_for_solving_timeout() -> void:
	if problem_active and not has_answered: # prevent double triggers if answer was already given
		# RESET the keyboard 
		keyboard.reset_input()
		
		solve_timer_display.visible = false
		level_generator.get_node("ProblemLabel").visible = false
		
		anim.play("enemy_attack") # play the animation with a bit of delay to sync with damage
		await get_tree().create_timer(1.5).timeout
		
		player_health -= rng.randi_range(15, 20) # damage range of the enemy
		
		Leveldata.items_not_solved += 1
		update_health_ui()
		
		
		if player_health <= 0:
			anim.play("player_death") # death animation for player
			enemy_sprite.play("idle")
			Leveldata.player_win = false
			await end_game_after_delay()
			return
			
		problem_active = false
		resume_allowed = false
		prob_timer.start(rng.randi_range(2, 4))
		has_answered = false

func _on_keyboard_answer_submitted(answer_text: String) -> void: # this is where the input will take place
	var current_ans = level_generator.get_current_answer()
	if game_over: return # skip logic if game is over
	if not problem_active or has_answered: return
	
	has_answered = true # lock in answer to prevent re-pressing
	
	# Compare the submitted answer
	if answer_text == current_ans:
		# hide the timer and problem display after correct answer
		solve_timer_display.visible = false
		level_generator.get_node("ProblemLabel").visible = false
		
		# this gets the elapsed time since the start of the solve timer by subtracting the start time from current time
		var elapsed_time = (Time.get_ticks_msec() - problem_start_time) / 1000.0 # convert to seconds, since this is in milliseconds
		
		anim.play("player_attack") # play the animation with a bit of delay to sync with damage
		await get_tree().create_timer(1.0).timeout
		
		var total_time = solve_timer.wait_time
		var damage: int

		if elapsed_time <= total_time * 0.30: # if the player solves within 30% of the total time 
			damage = 20  
		elif elapsed_time > total_time * 0.75: # if the player takes too long to answer
			damage = 10
		else:
			damage = 15  # normal timing = standard damage

		enemy_health -= damage
		
		Leveldata.items_solved += 1
		update_health_ui()
		
		if enemy_health <= 0:
			anim.play("enemy_death") # death animation for enemy
			player_sprite.play("idle")
			Leveldata.player_win = true
			
			await end_game_after_delay()
			return
		
		solve_timer.stop() # stop the solve timer and start generate_problem timer
		prob_timer.start(rng.randi_range(2, 4))
		problem_active = false
		resume_allowed = false
	
	else:
		# WRONG answer
		if wrong:
			wrong.play()
		keyboard.reset_input() # Clear the wrong input immediately
		has_answered = false

func _process(_delta: float) -> void:
	if game_over: return # skip logic if game is over
	
	if Input.is_action_just_pressed("autokill"):
		enemy_health -= 100
		if enemy_health <= 0:
			anim.play("enemy_death") # death animation for enemy
			player_sprite.play("idle")
			Leveldata.player_win = true
			
			await end_game_after_delay()
			return
	
	if solve_timer.is_stopped():
		solve_timer_display.visible = false
	else:
		var time_left = (solve_timer_end_time - Time.get_ticks_msec()) / 1000.0
		time_left = max(time_left, 0) # avoid showing negative numbers
		solve_timer_display.text = str("%.1f" % time_left) # show with 1 decimal place
		
		# Change color based on time left
		if time_left <= 7.0:
			solve_timer_display.add_theme_color_override("font_color", Color.RED)
		else:
			solve_timer_display.add_theme_color_override("font_color", Color.YELLOW)
			
	Leveldata.time_elapsed += _delta

func end_game_after_delay() -> void: # wait for a moment before ending the game
	
	game_over = true # prevent further interaction
	
	solve_timer.stop()
	prob_timer.stop()
	display.queue_free() # remove every UI element from screen
	
	await get_tree().create_timer(4.0).timeout # wait 5 seconds before final action

	# Now show a Game Over screen or quit
	Music.play_match_results()
	Functions.load_screen_to_scene("res://scenes/Whole game/Choose mode/campaign/Core gameplay/Match Result/match_results.tscn")

		
		
		
