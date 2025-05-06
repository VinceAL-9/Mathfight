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
			current_problem = "%d(%s + %d) + %d = %d, %s = ?" % [a, variable, b, c, rhs, variable]
			current_answer = "%d" % [sol]

		2:
			var sol = random_number(-7, 7, true)
			var a = random_number(2, 5, true)
			var b = random_number(2, 5, true)
			while a == b:
				b = random_number(2, 5, true)
			var c = random_number(-6, 6, true)
			var d = a * sol + c - b * sol
			current_problem = "%d%s + %d = %d%s + %d, %s = ?" % [a, variable, c, b, variable, d, variable]
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
			var answer_sign: String
			var sign_ = random_inequality()
			
			if sign_ == ">":
				# Equation: a*x + b < rhs
				# Solve: a*x < rhs - b → x > (rhs - b)/a → flip sign due to negative a
				answer_sign = "<"
			elif sign_ == "<":
				# Equation: a*x + b > rhs
				# Solve: a*x > rhs - b → x < (rhs - b)/a → flip sign due to negative a
				answer_sign = ">"
			
			var sol = random_number(-6, 6, true)
			var a = random_number(-8, -2)  # Always negative
			var b = random_number(-10, 10, true)
			

			# Calculate rhs such that the inequality is true when x == sol
			var lhs = a * sol + b
			var rhs = lhs  # Ensure solution works for sol
			
			var answer_val = sol


			current_problem = "Solve: %d%s + %d %s %d" % [a, variable, b, sign_, rhs]
			current_answer = "%s%s%d" % [variable, answer_sign, answer_val]

		5:
			# Generate a non-zero integer solution
			var sol = random_number(-6, 6, true)
			while sol == 0:
				sol = random_number(-6, 6, true)

			# Generate distinct multipliers for each side
			var a = random_number(2, 6)
			var c = random_number(2, 6)
			while a == c:
				c = random_number(2, 6)

			# Generate different offsets (b and d)
			var b = random_number(-4, 4, true)
			var d = random_number(-4, 4, true)
			while b == d:
				d = random_number(-4, 4, true)

			# Build lhs and rhs using distributive property
			var lhs = a * (sol + b)
			var rhs = c * (sol + d)

			# Ensure expressions are not trivially equal
			while lhs == rhs:
				d += 1 if d < 4 else -1
				rhs = c * (sol + d)

			# Final equation that must be solved by distribution
			current_problem = "%d(%s + %d) = %d(%s + %d), %s = ?" % [a, variable, b, c, variable, d, variable]
			current_answer = "%d" % [sol]

	problem_label.text = current_problem

func get_current_answer() -> String:
	return current_answer
