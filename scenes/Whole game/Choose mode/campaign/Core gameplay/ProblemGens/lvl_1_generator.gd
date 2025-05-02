extends Control

@onready var problem_label: Label = $ProblemLabel

# Variable letters and operators to choose from
var variables = ["x", "y"]
var operators = ["+", "-"]

# Tracks the current problem and its correct answer
var current_problem: String
var current_answer: String

func _ready():
	randomize()
	generate_problem()

# Returns a random number in the given range
func random_number(minimum, maximum):
	return randi() % (maximum - minimum + 1) + minimum

# Returns a random variable (x or y)
func random_variable():
	return variables[randi() % variables.size()]

# Returns a random operator (+ or -)
func random_operator():
	return operators[randi() % operators.size()]

# Formats a term like 3x, -x, or just x
func format_term(coefficient: int, variable: String) -> String:
	if coefficient == 0:
		return ""
	elif coefficient == 1:
		return variable
	elif coefficient == -1:
		return "-" + variable
	else:
		return str(coefficient) + variable

# Main problem generator
func generate_problem():
	var topic_type = random_number(1, 3)  # Choose topic 1, 2, or 3
	var variable = random_variable()

	match topic_type:
		### 1. Simplifying Expressions
		1:
			var mode = random_number(1, 2)  # Choose between simple and distributive
			if mode == 1:
				# Simple like: 3x - 2x
				var c1 = random_number(-10, 10)
				var c2 = random_number(-10, 10)
				while c1 == 0 and c2 == 0:
					c1 = random_number(-10, 10)
					c2 = random_number(-10, 10)

				var result = c1 + c2
				current_problem = "%s %s %s" % [
					format_term(c1, variable),
					"+" if c2 >= 0 else "-",
					format_term(abs(c2), variable)
				]
				current_answer = format_term(result, variable)
			else:
				# Distributive: a(bx + c)
				var a = random_number(-5, 5)
				while a == 0:
					a = random_number(-5, 5)
				var b = random_number(-5, 5)
				var c = random_number(-5, 5)

				var term_inside = "%s%s %s %d" % [
					"" if b == 1 else str(b),
					variable,
					"+" if c >= 0 else "-",
					abs(c)
				]
				current_problem = "%d(%s)" % [a, term_inside]

				# Distribute a*(bx + c)
				var final_coeff = a * b
				var final_const = a * c
				var expression = []
				if final_coeff != 0:
					expression.append(format_term(final_coeff, variable))
				if final_const != 0:
					expression.append("%+d" % final_const)
				current_answer = " ".join(expression)

		### 2. One-step Equation
		2:
			var solution = random_number(-10, 10)
			var op = random_operator()
			var coeff = random_number(3, 10)

			if op == "+":
				var rhs = solution + coeff
				current_problem = "%s + %d = %d" % [variable, coeff, rhs]
				current_answer = "%s=%d" % [variable, solution]
			else:
				var lhs = coeff * solution
				current_problem = "%d%s = %d" % [coeff, variable, lhs]
				current_answer = "%s=%d" % [variable, solution]

		### 3. Evaluating an Expression
		3:
			var value = random_number(-5, 10)
			var coeff = random_number(1, 10)
			var constant = random_number(-10, 10)

			current_problem = "Evaluate: %d%s %s %d for %s = %d" % [
				coeff,
				variable,
				"+" if constant >= 0 else "-",
				abs(constant),
				variable,
				value
			]
			current_answer = str(coeff * value + constant)

	# Show the problem to the player
	problem_label.text = current_problem

# Getter function for checking answers externally
func get_current_answer() -> String:
	return current_answer
