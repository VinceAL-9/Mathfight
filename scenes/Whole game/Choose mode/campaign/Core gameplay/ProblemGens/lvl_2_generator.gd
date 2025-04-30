extends Control

@onready var problem_label: Label = $ProblemLabel

var variables = ["x", "y"]
var operators = ["+", "-"]
var inequality_signs = ["<", ">"]  # Only strict inequalities

var current_problem: String
var current_answer: String

func _ready():
	randomize()
	generate_problem()

func random_number(minimum: int, maximum: int, allow_negative: bool = false) -> int:
	var num = randi() % (maximum - minimum + 1) + minimum
	return -num if allow_negative and randi() % 2 == 0 else num

func random_variable() -> String:
	return variables[randi() % variables.size()]

func random_operator() -> String:
	return operators[randi() % operators.size()]

func random_inequality() -> String:
	return inequality_signs[randi() % inequality_signs.size()]

func generate_problem():
	var problem_type = random_number(1, 3)
	var variable = random_variable()

	match problem_type:
		1:  # Multi-step equation: a(x + b) + c = value
			var sol = random_number(-10, 10)
			var a = random_number(1, 5, true)
			var b = random_number(-5, 5)
			var c = random_number(-10, 10)
			var rhs_value = a * (sol + b) + c

			current_problem = "Solve: %d(%s + %d) + %d = %d" % [a, variable, b, c, rhs_value]
			current_answer = "%s=%d" % [variable, sol]

		2:  # Variables on both sides: ax + c = bx + d
			var sol = random_number(-10, 10)
			var a = random_number(1, 5, true)
			var b = random_number(1, 5, true)
			
			while a == b:
				b = random_number(1, 5, true)  # Ensure coefficients are different for solvable equation

			var c = random_number(-10, 10)
			var lhs = a * sol + c

			var d = lhs - b * sol  # Ensures both sides equal when x = sol
			current_problem = "Solve: %d%s + %d = %d%s + %d" % [a, variable, c, b, variable, d]
			current_answer = "%s=%d" % [variable, sol]

		3:  # Inequality: ax + b < value
			var sol = random_number(-5, 5)
			var a = random_number(1, 5)
			var b = random_number(-10, 10)
			var sign_ = random_inequality()

			var rhs_value = a * sol + b
			current_problem = "Solve: %d%s + %d %s %d" % [a, variable, b, sign_, rhs_value]
			current_answer = "%s%s%d" % [variable, sign_, sol]

	problem_label.text = current_problem

func get_current_answer() -> String:
	return current_answer
