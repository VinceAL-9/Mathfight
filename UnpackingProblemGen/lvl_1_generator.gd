extends Node2D

# Arrays for random elements
var variables = ["x", "y", "z"]  # Common variable letters
var operators = ["+", "-"]  # Operators for expressions
var superscripts = {2: "²", 3: "³", 4: "⁴", 5: "⁵"}  # Superscripts for exponents

# Countdown variables
var countdown_texts = ["3", "2", "1", "Go!"]  # Countdown sequence
var countdown_index = 0  # Tracks the current countdown step

# Timer node for handling countdowns and pauses
@onready var main_timer = $MainTimer  # Timer node in your scene

# Function to generate a random number within a smaller range
func random_number(min, max):
	return randi() % (max - min + 1) + min

# Function to generate a random variable
func random_variable():
	var random_index = randi() % variables.size()
	return variables[random_index]

# Function to generate a random operator
func random_operator():
	var random_index = randi() % operators.size()
	return operators[random_index]

# Function to replace exponent numbers with superscripts
func get_superscript(exponent):
	if exponent in superscripts:
		return superscripts[exponent]
	return "^" + str(exponent)  # Default fallback if superscript is missing

# Function to generate algebra problems dynamically
func generate_algebra_problem():
	var problem_type = random_number(1, 2)  # 1 = Simplify Expression, 2 = Solve Equation
	var chosen_variable = random_variable()  # Choose a variable

	if problem_type == 1:  # Simplifying expressions
		var term1 = str(random_number(1, 10)) + chosen_variable
		var term2 = str(random_number(1, 10)) + chosen_variable
		return term1 + " " + random_operator() + " " + term2  # Combine like terms
	elif problem_type == 2:  # Solving one-step equations
		var coefficient = random_number(1, 10)
		var solution = random_number(1, 20)
		if random_operator() == "+":
			return chosen_variable + " + " + str(coefficient) + " = " + str(solution + coefficient)
		else:
			return str(coefficient) + chosen_variable + " = " + str(coefficient * solution)

# Function to handle the countdown phase
func start_countdown():
	countdown_index = 0  # Reset countdown index
	main_timer.start(0.1)  # Small initial delay to display "3" immediately
	update_counter_text()  # Immediately update the first countdown message

# Function to update the counter label during the countdown
func update_counter_text():
	$counter.text = countdown_texts[countdown_index]  # Display current countdown text

# Timer timeout handler for countdown and problem-solving phases
func _on_main_timer_timeout():
	if countdown_index < countdown_texts.size():  # Countdown phase
		update_counter_text()  # Show the current countdown message
		countdown_index += 1  # Move to the next step
		main_timer.start(1.0)  # Restart the timer for the countdown
	else:  # Problem-solving phase
		var problem = generate_algebra_problem()  # Generate a new algebra problem
		$Level1_prob.text = problem  # Display the problem
		$counter.text = "Solve the problem!"  # Update counter message for solving phase
		main_timer.start(3.0)  # Pause for 10 seconds for user to solve the problem

# Timer timeout handler for pausing phase (user's solving time)
func _on_pause_timer_timeout():
	start_countdown()  # Begin the countdown again after 3 seconds

# When the 3-second pause ends, restart the cycle
func restart_cycle():
	start_countdown()  # Begin the countdown again

# Automatically called when the scene loads
func _ready():
	start_countdown()  # Start the countdown as soon as the scene loads

func _on_button_back_pressed() -> void:
	get_tree().change_scene_to_file("res://prev_scene.tscn")
