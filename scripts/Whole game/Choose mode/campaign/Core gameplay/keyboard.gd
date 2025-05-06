extends Control

# UI Node
@onready var label = $VBoxContainer/MarginContainer/Label
@onready var button_sfx: AudioStreamPlayer = $Button_SFX

func _input(event):
	if not typing_enabled:
		return

	if event is InputEventKey and event.pressed:
		var _key_char = event.as_text()

		# Ignore Shift alone
		if event.keycode == Key.KEY_SHIFT:
			return

		# Numbers 0–9
		if event.keycode == Key.KEY_0 and not event.shift_pressed: key_pressed("0")
		elif event.keycode == Key.KEY_1: key_pressed("1")
		elif event.keycode == Key.KEY_2: key_pressed("2")
		elif event.keycode == Key.KEY_3: key_pressed("3")
		elif event.keycode == Key.KEY_4: key_pressed("4")
		elif event.keycode == Key.KEY_5: key_pressed("5")
		elif event.keycode == Key.KEY_6 and not event.shift_pressed: key_pressed("6")
		elif event.keycode == Key.KEY_7: key_pressed("7")
		elif event.keycode == Key.KEY_8: key_pressed("8")
		elif event.keycode == Key.KEY_9 and not event.shift_pressed: key_pressed("9")

		# Operators
		elif event.keycode == Key.KEY_EQUAL and event.shift_pressed: key_pressed("+")  # + is Shift + =
		elif event.keycode == Key.KEY_MINUS: key_pressed("-")

		# Parentheses Fix (Explicitly detect Shift + 9 and Shift + 0)
		elif event.keycode == Key.KEY_9 and event.shift_pressed: key_pressed("(")
		elif event.keycode == Key.KEY_0 and event.shift_pressed: key_pressed(")")

		# Raised exponent (Shift + 6 → ^)
		elif event.keycode == Key.KEY_6 and event.shift_pressed: key_pressed("^")

		# Comparison signs
		elif event.keycode == Key.KEY_COMMA and event.shift_pressed: key_pressed("<")
		elif event.keycode == Key.KEY_PERIOD and event.shift_pressed: key_pressed(">")

		# Variables
		elif event.keycode == Key.KEY_X: key_pressed("x")
		elif event.keycode == Key.KEY_Y: key_pressed("y")

		# Enter key detection
		elif event.keycode == Key.KEY_ENTER:
			_on_button_ok_pressed()

		# Backspace
		elif event.keycode == Key.KEY_BACKSPACE:
			_on_button_backspace_pressed()

# signal for answer submission
signal answer_submitted(answer_text: String)

# variables
var typing_enabled: bool  # Whether player is allowed to type, prevents spam inputs

# functions

func _ready() -> void:
	
	# Clear label and enable typing
	label.text = ""
	typing_enabled = true

# Adds sound effects when pressing number buttons
func key_pressed(character) -> void:
	if button_sfx:
		button_sfx.play()
	
	if not typing_enabled:
		return
	
	var char_str := str(character)

	label.text += char_str

# when "1" key is pressed it will input 1
func _on_button_1_pressed() -> void:
	key_pressed("1")

# when "2" key is pressed it will input 2
func _on_button_2_pressed() -> void:
	key_pressed("2")

# when "3" key is pressed it will input 3
func _on_button_3_pressed() -> void:
	key_pressed("3")

# when "4" key is pressed it will input 4
func _on_button_4_pressed() -> void:
	key_pressed("4")

# when "5" key is pressed it will input 5
func _on_button_5_pressed() -> void:
	key_pressed("5")

# when "6" key is pressed it will input 6
func _on_button_6_pressed() -> void:
	key_pressed("6")

# when "7" key is pressed it will input 7
func _on_button_7_pressed() -> void:
	key_pressed("7")

# when "8" key is pressed it will input 8
func _on_button_8_pressed() -> void:
	key_pressed("8")

# when "9" key is pressed it will input 9
func _on_button_9_pressed() -> void:
	key_pressed("9")

# when "0" key is pressed it will input 0
func _on_button_0_pressed() -> void:
	key_pressed("0")

# removes a character in the answer when pressed
func _on_button_backspace_pressed() -> void:
	if button_sfx:
		button_sfx.play()
	
	# Allow backspace only if typing is allowed
	if not typing_enabled:
		return
	
	# Removes the last character from the label
	if label.text.length() > 0:
		label.text = label.text.substr(0, label.text.length() - 1)
	
# when "+" key is pressed it will input +
func _on_buttonplus_pressed() -> void:
	key_pressed("+")

# when "-" key is pressed it will input -
func _on_buttonminus_pressed() -> void:
	key_pressed("-")

# when "x" key is pressed it will input x
func _on_buttonx_pressed() -> void:
	key_pressed("x")

# when ")" key is pressed it will input )
func _on_button_closedparenthesis_pressed() -> void:
	key_pressed(")")

# when ">" key is pressed it will input >
func _on_buttongreaterthan_pressed() -> void:
	key_pressed(">")
	
	# when "<" key is pressed it will input <
func _on_buttonlessthan_pressed() -> void:
	key_pressed("<")

# when "y" key is pressed it will input y
func _on_buttony_pressed() -> void:
	key_pressed("y")

# when "A^" key is pressed it will input a ^ to indicate an exponent
func _on_button_raised_pressed() -> void:
	if button_sfx:
		button_sfx.play()
	if typing_enabled:
		key_pressed("^")

# when "(" key is pressed it will input (
func _on_button_openparenthesis_pressed() -> void:
	if typing_enabled:
		key_pressed("(")

# when it will submit your answer and check if it is correct.
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
	
	typing_enabled = true

func reset_input() -> void: # call this function to manually reset keyboard input
	label.text = ""
	label.remove_theme_color_override("font_color")
	
	typing_enabled = true
