extends Node2D

@onready var problem_label: Label = $ProblemLabel

var variables = ["x", "y"]
var operators = ["+", "-"]
var inequality_signs = ["<", ">"] # signs without the version with equal 

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
		1:  # Multi-step equation
			var a = random_number(1, 5, true)
			var b = random_number(1, 10)
			var c = random_number(1, 10)
			var sol = random_number(1, 10, true)

			var lhs_expr = "%d(%s + %d) + %d" % [a, variable, b, c]
			var rhs_value = a * (sol + b) + c
			current_problem = "%s = %d" % [lhs_expr, rhs_value]
			current_answer = "%s=%d" % [variable, sol]

		2:  # Variables on both sides
			var sol = random_number(1, 10, true)
			var a = random_number(1, 5, true)
			var b = random_number(1, 5, true)
			var c = random_number(1, 10)
			var d = random_number(1, 10)

			var _lhs = a * sol + c
			var _rhs = b * sol + d
			current_problem = "%d%s + %d = %d%s + %d" % [a, variable, c, b, variable, d]
			current_answer = "%s=%d" % [variable, sol]

		3:  # Inequality
			var sol = random_number(-5, 5)
			var a = random_number(1, 5)
			var b = random_number(1, 10)
			var sign_ = random_inequality()

			var lhs_expr = "%d%s + %d" % [a, variable, b]
			var rhs_value = a * sol + b
			current_problem = "%s %s %d" % [lhs_expr, sign_, rhs_value]
			current_answer = "%s%s%d" % [variable, sign_, sol]

	problem_label.text = current_problem

func get_current_answer() -> String:
	return current_answer
