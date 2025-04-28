extends Node

# UI Node
@onready var label = $VBoxContainer/MarginContainer/Label
@onready var button_sfx: AudioStreamPlayer = $Button_SFX
# constants
const SUPERSCRIPT_MAP := {
	"0": "⁰", "1": "¹", "2": "²", "3": "³", "4": "⁴",
	"5": "⁵", "6": "⁶", "7": "⁷", "8": "⁸", "9": "⁹"
}

# signal for answer submission
signal answer_submitted(answer_text: String)

# variables
var next_char_superscript: bool = false  # Whether the next digit should be superscript
var sqrt_open: bool = false              # Whether we're inside a √(...) expression
var parenthesis_open: bool = false        # Whether a standalone ( ) is open
var typing_enabled: bool  # Whether player is allowed to type, prevents spam inputs

# functions

func _ready() -> void:
	
	# Clear label and enable typing
	label.text = ""
	typing_enabled = true

func key_pressed(character) -> void:
	if button_sfx:
		button_sfx.play()
	
	# Prevent typing if typing is disabled
	if not typing_enabled:
		return
	
	# Handles typing a character into the label, considering superscript state
	var char_str := str(character)
	
	if next_char_superscript and char_str.is_valid_int():
		# If superscript mode active and character is a digit, convert it
		label.text += SUPERSCRIPT_MAP.get(char_str, char_str)
		next_char_superscript = false
	else:
		label.text += char_str

func _on_button_1_pressed() -> void:
	key_pressed(1)


func _on_button_2_pressed() -> void:
	key_pressed(2)


func _on_button_3_pressed() -> void:
	key_pressed(3)


func _on_button_4_pressed() -> void:
	key_pressed(4)


func _on_button_5_pressed() -> void:
	key_pressed(5)


func _on_button_6_pressed() -> void:
	key_pressed(6)


func _on_button_7_pressed() -> void:
	key_pressed(7)


func _on_button_8_pressed() -> void:
	key_pressed(8)


func _on_button_9_pressed() -> void:
	key_pressed(9)


func _on_button_0_pressed() -> void:
	key_pressed(0)

func _on_button_backspace_pressed() -> void:
	if button_sfx:
		button_sfx.play()
	
	# Allow backspace only if typing is allowed
	if not typing_enabled:
		return
	
	# Removes the last character from the label
	if label.text.length() > 0:
		label.text = label.text.substr(0, label.text.length() - 1)
	

func _on_buttonplus_pressed() -> void:
	key_pressed("+")


func _on_buttonminus_pressed() -> void:
	key_pressed("-")


func _on_buttonx_pressed() -> void:
	key_pressed("x")


func _on_buttondivide_pressed() -> void:
	key_pressed("÷")


func _on_buttonmultiply_pressed() -> void:
	key_pressed("*")


func _on_buttony_pressed() -> void:
	key_pressed("y")



func _on_button_sqrt_pressed() -> void:
	# Prevent sqrt toggling if typing is disabled
	if not typing_enabled:
		return
	
	# Toggles sqrt expression: inserts "√(" and later ")"
	if sqrt_open:
		# Close the sqrt first if it's open
		key_pressed(")")
		sqrt_open = false
	elif parenthesis_open:
		key_pressed(")")
		parenthesis_open = false
	else:
		key_pressed("√(")
		parenthesis_open = true
	

func _on_button_raised_pressed() -> void:
	if button_sfx:
		button_sfx.play()
	# Activates superscript mode for next character
	if typing_enabled:
		next_char_superscript = true

func _on_button_parenthesis_pressed() -> void:
	if not typing_enabled:
		return

	# Toggle normal parentheses
	if parenthesis_open:
		key_pressed(")")
	else:
		key_pressed("(")
	parenthesis_open = not parenthesis_open

func _on_button_ok_pressed() -> void:
	if button_sfx:
		button_sfx.play()
	
	# prevent spam clicking OK
	if not typing_enabled:
		return
	
	# Disallow further typing
	typing_enabled = false
	
	# Compares the typed answer with the correct answer
	emit_signal("answer_submitted", label.text)
	
	label.text = ""
	label.remove_theme_color_override("font_color")
	next_char_superscript = false
	sqrt_open = false
	parenthesis_open = false
	typing_enabled = true

func reset_input() -> void: # call this function to manually reset keyboard input
	label.text = ""
	label.remove_theme_color_override("font_color")
	next_char_superscript = false
	sqrt_open = false
	parenthesis_open = false
	typing_enabled = true
