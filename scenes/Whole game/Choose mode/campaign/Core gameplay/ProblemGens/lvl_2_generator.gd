extends Control

@onready var problem_label: Label = $ProblemLabel

# Arrays of possible variable names and inequality signs
var variables = ["x", "y"]
var inequality_signs = ["<", ">"]  # Strict inequalities only

# Stores the generated problem and correct answer
var current_problem: String
var current_answer: String

func _ready():
	randomize()
	generate_problem()

# Returns a random integer between minimum and maximum
# Optionally allows the number to be negative
func random_number(minimum: int, maximum: int, allow_negative: bool = false) -> int:
	var num = randi() % (maximum - minimum + 1) + minimum
	return -num if allow_negative and randi() % 2 == 0 else num

# Returns a random variable name (x or y)
func random_variable() -> String:
	return variables[randi() % variables.size()]

# Returns a random inequality sign (< or >)
func random_inequality() -> String:
	return inequality_signs[randi() % inequality_signs.size()]

# Generates and stores a new algebra problem and its solution
func generate_problem():
	var problem_type = random_number(1, 4)  # Pick which type of problem to generate
	var variable = random_variable()

	match problem_type:
		1:  
			# Multi-step equation using distributive property: a(x + b) + c = value
			var sol = random_number(-10, 10)  # Pick the actual solution for x
			var a = random_number(1, 5, true)  # Coefficient for distribution (can be negative)
			var b = random_number(-5, 5)       # Inside-parenthesis constant
			var c = random_number(-10, 10)     # Outside constant
			var rhs = a * (sol + b) + c        # Evaluate RHS using chosen solution

			current_problem = "Solve: %d(%s + %d) + %d = %d" % [a, variable, b, c, rhs]
			current_answer = "%s=%d" % [variable, sol]

		2:
			# Equation with variables on both sides: ax + c = bx + d
			var sol = random_number(-10, 10)
			var a = random_number(1, 4, true)  # Coefficient on LHS
			var b = random_number(1, 4, true)  # Coefficient on RHS
			while a == b:
				b = random_number(1, 4, true)  # Ensure a ≠ b so it’s solvable

			var c = random_number(-5, 5)
			var d = a * sol + c - b * sol  # Construct RHS so x = sol is correct

			current_problem = "Solve: %d%s + %d = %d%s + %d" % [a, variable, c, b, variable, d]
			current_answer = "%s=%d" % [variable, sol]

		3:
			# Linear inequality: ax + b < c
			var sol = random_number(-5, 5)
			var a = random_number(1, 4, true)
			var b = random_number(-10, 10)
			var sign_ = random_inequality()
			var rhs = a * sol + b  # Calculate RHS to make solution valid

			current_problem = "Solve: %d%s + %d %s %d" % [a, variable, b, sign_, rhs]
			current_answer = "%s%s%d" % [variable, sign_, sol]

		4:
			# Equation with distribution on both sides: a(x + b) = c(x + d)
			var sol = random_number(-5, 5)
			var a = random_number(1, 3, true)
			var b = random_number(-3, 3)
			var c = random_number(1, 3, true)
			var d = random_number(-3, 3)

			var lhs = a * (sol + b)
			var rhs = c * (sol + d)

			if lhs == rhs:
				# Adjust slightly if both sides evaluate to the same value (avoid trivial solution)
				d += 1
				rhs = c * (sol + d)

			current_problem = "Solve: %d(%s + %d) = %d(%s + %d)" % [a, variable, b, c, variable, d]
			current_answer = "%s=%d" % [variable, sol]

	# Update the problem label text for display
	problem_label.text = current_problem

# Provides the answer to the currently generated problem
func get_current_answer() -> String:
	return current_answer
