extends Control

@onready var problem_label: Label = $ProblemLabel

var variables = ["x", "y"]
var inequality_signs = ["<", ">"]

var current_problem: String
var current_answer: String

func _ready():
	randomize()
	generate_problem()

func random_number(minimum: int, maximum: int, allow_negative: bool = false) -> int:
	var num = 0
	while num == 0:
		num = randi() % (maximum - minimum + 1) + minimum
		if allow_negative and randi() % 2 == 0:
			num = -num
	return num

func random_variable() -> String:
	return variables[randi() % variables.size()]

func random_inequality() -> String:
	return inequality_signs[randi() % inequality_signs.size()]

func generate_problem():
	var problem_type = random_number(1, 5)
	var variable = random_variable()

	match problem_type:
		1:
			var sol = random_number(-8, 8, true)
			var a = random_number(2, 6, true)
			var b = random_number(-5, 5, true)
			var c = random_number(-8, 8, true)
			var rhs = a * (sol + b) + c
			current_problem = "Solve: %d(%s + %d) + %d = %d" % [a, variable, b, c, rhs]
			current_answer = "%d" % [sol]

		2:
			var sol = random_number(-7, 7, true)
			var a = random_number(2, 5, true)
			var b = random_number(2, 5, true)
			while a == b:
				b = random_number(2, 5, true)
			var c = random_number(-6, 6, true)
			var d = a * sol + c - b * sol
			current_problem = "Solve: %d%s + %d = %d%s + %d" % [a, variable, c, b, variable, d]
			current_answer = "%d" % [sol]

		3:
			var sol = random_number(-6, 6, true)
			var a = random_number(2, 8, true)
			var b = random_number(-10, 10, true)
			var sign_ = random_inequality()
			var rhs = a * sol + b
			var b_term = "%s %d" % [("+" if b >= 0 else "-"), abs(b)]
			current_problem = "Solve: %d%s %s %s %d" % [a, variable, b_term, sign_, rhs]
			current_answer = "%s%s%d" % [variable, sign_, sol]

		4:
			var sol = random_number(-6, 6, true)
			var a = random_number(-8, -2)  # Always negative
			var b = random_number(-10, 10, true)
			var sign_ = random_inequality()
			var rhs = a * sol + b
			var flipped_sign = ""
			match sign_:
				"<": flipped_sign = ">"
				">": flipped_sign = "<"
			current_problem = "Solve: %d%s + %d %s %d" % [a, variable, b, sign_, rhs]
			current_answer = "%s%s%d" % [variable, flipped_sign, sol]

		5:
			var sol = random_number(-6, 6, true)
			var a = random_number(2, 6, true)
			var b = random_number(-4, 4, true)
			var c = random_number(2, 6, true)
			var d = random_number(-4, 4, true)
			var lhs = a * (sol + b)
			var rhs = c * (sol + d)
			if lhs == rhs:
				d += 1 if d < 4 else -1
				rhs = c * (sol + d)
			current_problem = "Solve: %d(%s + %d) = %d(%s + %d)" % [a, variable, b, c, variable, d]
			current_answer = "%d" % [sol]

	problem_label.text = current_problem

func get_current_answer() -> String:
	return current_answer
