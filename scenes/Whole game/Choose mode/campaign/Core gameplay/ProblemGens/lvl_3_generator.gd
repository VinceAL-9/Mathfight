extends Control

@onready var problem_label: Label = $ProblemLabel

var variables = ["x", "y"]
var operators = ["+", "-"]

var current_problem: String
var current_answer: String

func _ready():
	randomize()
	generate_problem()

func random_number(minimum: int, maximum: int, allow_negative := false) -> int:
	var num = randi() % (maximum - minimum + 1) + minimum
	return -num if allow_negative and randi() % 2 == 0 else num

func random_variable() -> String:
	return variables[randi() % variables.size()]

func random_operator() -> String:
	return operators[randi() % operators.size()]

func get_exponent(base: String, exponent: int) -> String:
	return "%s^%d" % [base, exponent]

func generate_problem():
	var type = random_number(1, 4)
	var v = random_variable()

	match type:
		1:  # Laws of Exponents (multiplication, division, power)
			var a = random_number(2, 6)
			var b = random_number(2, 6)
			var law_type = random_number(1, 3)

			if law_type == 1:
				# x² × x³ => x⁵
				current_problem = "Simplify: %s  ×  %s" % [get_exponent(v, a), get_exponent(v, b)]
				current_answer = get_exponent(v, a + b)
			elif law_type == 2:
				# x⁴ / x² => x², or x³ / x² => x
				var larger = max(a, b)
				var smaller = min(a, b)
				var result_exp = larger - smaller
				current_problem = "Simplify: %s  /  %s" % [get_exponent(v, larger), get_exponent(v, smaller)]
				
				# If result is exponent 1, just show the variable
				current_answer = v if result_exp == 1 else get_exponent(v, result_exp)
			else:
				# (x²)³ => x⁶
				current_problem = "Simplify: (%s)^%d" % [get_exponent(v, a), b]
				current_answer = get_exponent(v, a * b)

		2:  # Simplifying expressions like 3x² + 2x² = 5x²
			var coef1 = random_number(1, 9)
			var coef2 = random_number(1, 9)
			var total = coef1 + coef2
			current_problem = "Simplify: %d%s + %d%s" % [coef1, get_exponent(v, 2), coef2, get_exponent(v, 2)]
			current_answer = "%d%s" % [total, get_exponent(v, 2)]

		3:  # Factoring common term: 4x + 8 => 4(x + 2)
			var factor = random_number(2, 13)
			var addend = random_number(1, 15)
			var term1 = factor * 1  # 1x
			var term2 = factor * addend
			current_problem = "Factor: %d%s + %d" % [term1, v, term2]
			current_answer = "%d(%s+%d)" % [factor, v, addend]

		4:  # Quadratic factoring: x² + 5x + 6 = (x + 2)(x + 3)
			var r1 = random_number(1, 11)
			var r2 = random_number(1, 11)
			var sum_ = r1 + r2
			var prod = r1 * r2
			current_problem = "Factor: %s + %d%s + %d = 0" % [get_exponent(v, 2), sum_, v, prod]
			current_answer = "(%s+%d)(%s+%d)" % [v, r1, v, r2] + "(%s+%d)(%s+%d)" % [v, r2, v, r1]

	problem_label.text = current_problem

func get_current_answer() -> String:
	return current_answer

	
