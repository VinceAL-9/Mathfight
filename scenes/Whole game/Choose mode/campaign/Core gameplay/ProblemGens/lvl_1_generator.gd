extends Node2D

@onready var problem_label: Label = $ProblemLabel

# Arrays for random elements
var variables = ["x", "y"]  # Common variable letters
var operators = ["+", "-"]  # Operators for expressions
var superscripts = {2: "²", 3: "³", 4: "⁴", 5: "⁵"}  # Superscripts for exponents

# Holds the latest problem and answer
var current_problem: String
var current_answer: String


func _ready():
	randomize()
	generate_problem()  # Generate one on startup

func random_number(mininmum, maximum):
	return randi() % (maximum - mininmum + 1) + mininmum

func random_variable():
	return variables[randi() % variables.size()]

func random_operator():
	return operators[randi() % operators.size()]

func get_superscript(exponent):
	return superscripts.get(exponent, "^" + str(exponent))

# Generates and stores a new problem + its answer
func generate_problem():
	var topic_type = random_number(1, 3)
	var variable = random_variable()

	match topic_type:
		1:  # Simplifying expression
			var c1 = random_number(1, 10)
			var c2 = random_number(1, 10)
			var op = random_operator()
			current_problem = "%s%s %s %s%s" % [c1, variable, op, c2, variable]
			current_answer = str(c1 + c2) + variable if op == "+" else str(c1 - c2) + variable
		2:  # Solving one-step equation
			var coeff = random_number(1, 10)
			var solution = random_number(-10, 10)  # include negatives
			var op = random_operator()
			if op == "+":
				current_problem = "%s + %d = %d" % [variable, coeff, solution + coeff]
				current_answer = "%s = %d" % [variable, solution]
			else:
				current_problem = "%d%s = %d" % [coeff, variable, coeff * solution]
				current_answer = "%s=%d" % [variable, solution]
		3:  # Evaluating algebraic expression
			var value = random_number(1, 10)
			var coeff = random_number(1, 5)
			var constant = random_number(1, 10)
			current_problem = "Evaluate: %d%s + %d for %s = %d" % [coeff, variable, constant, variable, value]
			current_answer = str(coeff * value + constant)
	
	# Update label text
	problem_label.text = current_problem

# Provide access to the current answer for backend use
func get_current_answer() -> String:
	return current_answer
