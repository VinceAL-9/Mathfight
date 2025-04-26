extends Node

# UI Node
@onready var label = $VBoxContainer/MarginContainer/Label

# constants
const ANSWER := "x²+12x-32"  # The correct answer to match when OK is pressed
const SUPERSCRIPT_MAP := {
	"0": "⁰", "1": "¹", "2": "²", "3": "³", "4": "⁴",
	"5": "⁵", "6": "⁶", "7": "⁷", "8": "⁸", "9": "⁹"
}

# variables
var next_char_superscript: bool = false  # Whether the next digit should be superscript
var sqrt_open: bool = false              # Whether we're inside a √(...) expression
var parenthesis_open: bool = false        # Whether a standalone ( ) is open

# functions

func _ready() -> void:
	# Initial text to instruct the player
	label.text = "Answer Quickly"
	
	# After 1 second, clear the text to allow typing
	await get_tree().create_timer(1.0).timeout
	label.text = ""

func key_pressed(character) -> void:
	# Handles typing a character into the label, considering superscript state
	var char_str := str(character)
	
	if next_char_superscript and char_str.is_valid_int():
		# If superscript mode active and character is a digit, convert it
		label.text += SUPERSCRIPT_MAP.get(char_str, char_str)
		next_char_superscript = false
	else:
		label.text += char_str

func _on_button_pressed(value: Variant) -> void:
	# General button handler for most inputs
	key_pressed(value)

func _on_button_backspace_pressed() -> void:
	# Removes the last character from the label
	if label.text.length() > 0:
		label.text = label.text.substr(0, label.text.length() - 1)

func _on_button_operator_pressed(operator: String) -> void:
	# Handles input for simple math operators like +, -, *, ÷
	key_pressed(operator)

func _on_button_variable_pressed(variable: String) -> void:
	# Handles input for variables like x, y
	key_pressed(variable)

func _on_button_sqrt_pressed() -> void:
	# Toggles sqrt expression: inserts "√(" and later ")"
	if sqrt_open:
		key_pressed(")")
	else:
		key_pressed("√(")
	sqrt_open = not sqrt_open

func _on_button_raised_pressed() -> void:
	# Activates superscript mode for next character
	next_char_superscript = true

func _on_button_parenthesis_pressed() -> void:
	# Toggles normal parentheses ()
	if parenthesis_open:
		key_pressed(")")
	else:
		key_pressed("(")
	parenthesis_open = not parenthesis_open

func _on_button_ok_pressed() -> void:
	# Compares the typed answer with the correct answer
	if label.text == ANSWER:
		label.text = "Nice Job!"
		label.add_theme_color_override("font_color", Color.GREEN)
	else:
		label.text = "Skill Issue"
		label.add_theme_color_override("font_color", Color.RED)
	
	# Wait a moment, then reset the label
	await get_tree().create_timer(2.0).timeout
	label.text = ""
	label.remove_theme_color_override("font_color")
