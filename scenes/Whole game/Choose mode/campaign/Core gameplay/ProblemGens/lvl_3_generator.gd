extends Control

@onready var problem_label: Label = $ProblemLabel

# Common variables and operators used in algebra problems
var variables = ["x", "y"]
var operators = ["+", "-"]

# Current algebra problem and its correct answer
var current_problem: String
var current_answer: String

func _ready():
	randomize()
	generate_problem()

# Generate a random integer in range (optionally negative)
func random_number(minimum: int, maximum: int, allow_negative := false) -> int:
	var num = randi() % (maximum - minimum + 1) + minimum
	return -num if allow_negative and randi() % 2 == 0 else num

# Get a random variable like 'x' or 'y'
func random_variable() -> String:
	return variables[randi() % variables.size()]

# Return exponent notation as string (e.g., x^2)
func get_exponent(base: String, exponent: int) -> String:
	return "%s^%d" % [base, exponent]

# Generate a level 3 algebra problem
func generate_problem():
	var type = random_number(1, 4)  # Choose one of 4 types
	var v = random_variable()

	match type:
		1:
			# Laws of Exponents: multiplication, division, power
			var a = random_number(2, 6)
			var b = random_number(2, 6)
			var law_type = random_number(1, 3)

			if law_type == 1:
				# Multiply: x^a * x^b = x^(a+b)
				current_problem = "Simplify: %s × %s" % [get_exponent(v, a), get_exponent(v, b)]
				current_answer = get_exponent(v, a + b)

			elif law_type == 2:
				# Divide: x^a / x^b = x^(a-b)
				var larger = max(a, b)
				var smaller = min(a, b)
				var result_exp = larger - smaller
				current_problem = "Simplify: %s / %s" % [get_exponent(v, larger), get_exponent(v, smaller)]
				current_answer = v if result_exp == 1 else get_exponent(v, result_exp)

			else:
				# Power of a power: (x^a)^b = x^(a*b)
				current_problem = "Simplify: (%s)^%d" % [get_exponent(v, a), b]
				current_answer = get_exponent(v, a * b)

		2:
			# Simplifying like terms: 3x + 5x OR 2x² + 7x²
			var coef1 = random_number(1, 15)
			var coef2 = random_number(1, 15)
			var use_squared = randi() % 2 == 0  # 50% chance

			var total = coef1 + coef2
			if use_squared:
				current_problem = "Simplify: %d%s + %d%s" % [coef1, get_exponent(v, 2), coef2, get_exponent(v, 2)]
				current_answer = "%d%s" % [total, get_exponent(v, 2)]
			else:
				current_problem = "Simplify: %d%s + %d%s" % [coef1, v, coef2, v]
				current_answer = "%d%s" % [total, v]

		3:
			# Factoring out GCF: could be addition or subtraction
			var factor = random_number(2, 11)
			var addend = random_number(1, 11)
			var op = operators[randi() % operators.size()]  # Randomly "+" or "-"

			var term1 = factor
			var term2 = factor * addend

			if op == "+":
				current_problem = "Factor: %d%s + %d" % [term1, v, term2]
				current_answer = "%d(%s+%d)" % [factor, v, addend]
			else:
				current_problem = "Factor: %d%s - %d" % [term1, v, term2]
				current_answer = "%d(%s-%d)" % [factor, v, addend]

		4:
			# Difference of squares: (x)^2 - 9 or (4x)^2 - 16
			var coeff_options = [1, 4, 9, 16, 25, 36, 49, 64, 81]  
			var coeff = coeff_options[randi() % coeff_options.size()]
			var a = random_number(2, 8)  # Keep numbers small
			var square = a * a

			if coeff == 1:
				current_problem = "Factor: %s - %d" % [get_exponent(v, 2), square]
				current_answer = "(%s+%d)(%s-%d)" % [v, a, v, a]
			else:
				current_problem = "Factor: %d%s^2 - %d" % [coeff, v, square]
				var sqrt_coeff = int(sqrt(coeff))
				current_answer = "(%d%s+%d)(%d%s-%d)" % [sqrt_coeff, v, a, sqrt_coeff, v, a]

	# Display the new problem
	problem_label.text = current_problem

# Provide current answer for checking logic
func get_current_answer() -> String:
	return current_answer

	
