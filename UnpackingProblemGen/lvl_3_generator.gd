extends Node2D

# Arrays for random elements
var variables = ["x", "y", "z", "a", "b", "c"]  # Common variable letters
var operators = ["+", "-"]  # Operators for expressions
var superscripts = {2: "²", 3: "³", 4: "⁴", 5: "⁵", 6: "⁶", 7: "⁷"}  # Superscripts for exponents

# Countdown variables
var countdown_texts = ["3", "2", "1", "Go!"]  # Countdown sequence
var countdown_index = 0  # Tracks the current countdown step

# Timer node for handling countdowns and pauses
@onready var main_timer : Timer = $MainTimer  # Timer node in your scene

# Function to generate a random number
func random_number(min: int, max: int, allow_negative: bool = false) -> int:
	var number = randi() % (max - min + 1) + min
	if allow_negative and randi() % 2 == 0:  # Randomly make the number negative
		return -number
	return number

# Function to generate a random variable
func random_variable() -> String:
	var random_index = randi() % variables.size()
	return variables[random_index]

# Function to generate a random operator
func random_operator() -> String:
	var random_index = randi() % operators.size()
	return operators[random_index]  # Select an operator from the list

# Function to format exponents with superscripts
func get_exponent(base: String, exponent: int) -> String:
	if exponent > 1 and exponent in superscripts:  # Skip exponent = 1
		return base + superscripts[exponent]
	return base  # No superscript for exponent = 1

# Function to generate algebra problems dynamically
func generate_algebra_problem() -> String:
	var problem_type = random_number(1, 5)  # Increase range to favor quadratic equations more
	var chosen_variable = random_variable()  # Choose a variable

	if problem_type <= 2:  # Quadratic equations with higher priority (40% chance)
		var root1 = random_number(1, 10, true)  # Allow negative roots
		var root2 = random_number(1, 10, true)
		var coefficient = random_number(1, 5)

		# Expand (coefficient * x - root1)(x - root2)
		var term1 = str(coefficient) + chosen_variable + superscripts.get(2, "^2")
		var term2 = str(-coefficient * (root1 + root2)) + " + " + chosen_variable  # Explicit operator included
		var term3 = str(random_number(1, 100))  # Constant capped at 100

		return term1 + " " + term2 + " + " + term3 + " = 0"

	elif problem_type == 3:  # Laws of exponents (20% chance)
		var base1 = chosen_variable
		var base2 = chosen_variable  # Same base to apply laws
		var exp1 = random_number(2, 7)  # Exponents range from 2 to 7
		var exp2 = random_number(2, 7)
		var operator_type = random_number(1, 3)  # 1 = Multiplication, 2 = Division, 3 = Power Rule

		if operator_type == 1:  # Multiplication (add exponents)
			return get_exponent(base1, exp1) + " × " + get_exponent(base2, exp2)
		elif operator_type == 2:  # Division (subtract exponents)
			return get_exponent(base1, exp1) + " / " + get_exponent(base2, exp2)
		else:  # Power rule (multiply exponents)
			return "(" + get_exponent(base1, exp1) + ")" + superscripts.get(exp2, "^" + str(exp2))

	else:  # Simplify exponential expressions (40% chance)
		var coefficient = random_number(1, 10)
		var base = chosen_variable
		var exp1 = random_number(2, 7)  # Exponents range from 2 to 7
		var exp2 = random_number(2, 7)
		var operator = random_operator()  # Use random_operator to insert an operator

		return str(coefficient) + " × " + get_exponent(base, exp1) + " " + operator + " " + get_exponent(base, exp2)

	return ""  # Fallback (shouldn't be reached)

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
		$Level3_prob.text = problem  # Display the problem
		$counter.text = "Solve the problem!"  # Update counter message for solving phase
		main_timer.start(10.0)  # Pause for 10 seconds for user to solve the problem

# Timer timeout handler for pausing phase (user's solving time)
func _on_pause_timer_timeout():
	start_countdown()  # Begin the countdown again after solving phase

# When the 10-second pause ends, restart the cycle
func restart_cycle():
	start_countdown()  # Begin the countdown again

# Automatically called when the scene loads
func _ready():
	start_countdown()  # Start the countdown as soon as the scene loads

func _on_back_pressed():
	get_tree().change_scene_to_file("res://prev_scene.tscn")
