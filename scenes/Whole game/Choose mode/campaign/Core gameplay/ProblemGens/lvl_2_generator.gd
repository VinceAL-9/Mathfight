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
	var problem_type = 5
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
			var sol = random_number(-6, 6, true)
			var a = random_number(-8, -2)  # Always negative
			var b = random_number(-10, 10, true)
			var sign_ = random_inequality()

			var lhs = a * sol + b
			var rhs = lhs  # Construct RHS so that x = sol is the true solution

			var answer_val = sol

			match sign_:
				">":
					# For a*x + b > rhs, since a is negative:
					# x < (rhs - b)/a → x < sol (sign flips)
					current_problem = "Solve: %d%s + %d > %d" % [a, variable, b, rhs]
					current_answer = "%s<%d" % [variable, answer_val]
					
				"<":
					# For a*x + b < rhs, since a is negative:
					# x > (rhs - b)/a → x > sol (sign flips)
					current_problem = "Solve: %d%s + %d < %d" % [a, variable, b, rhs]
					current_answer = "%s>%d" % [variable, answer_val]

		5:
			# Generate solution (-6 to 6, non-zero)
			var sol = random_number(-10, 10, true)
			while sol == 0:
				sol = random_number(-6, 6, true)

			# Generate a ≠ c
			var a = random_number(2, 6)
			var c = random_number(2, 6)
			while a == c:
				c = random_number(2, 6)

			# Calculate PROPER d to satisfy a(sol+b) = c(sol+d)
			var b = random_number(-4, 4, true)
			var d = (a * (sol + b) - c * sol) / c  # Corrected formula

			# Ensure d is integer in [-4, 4]
			while not (is_equal_approx(d, int(d))) or d < -4 or d > 4:
				b = random_number(-4, 4, true)
				d = (a * (sol + b) - c * sol) / c

			d = int(d)

			# Verify equation holds (NEW CRITICAL CHECK)
			if a * (sol + b) != c * (sol + d):
				# Regenerate entirely if violated
				generate_problem() #  restart the generation
			
			# Formatting (unchanged)
			var b_str = "+ %d" % b if b >= 0 else "- %d" % -b
			var d_str = "+ %d" % d if d >= 0 else "- %d" % -d

			current_problem = "%d(%s %s) = %d(%s %s), %s = ?" % [a, variable, b_str, c, variable, d_str, variable]
			current_answer = "%d" % [sol]  

	problem_label.text = current_problem
	
	
func get_current_answer() -> String:
	return current_answer
