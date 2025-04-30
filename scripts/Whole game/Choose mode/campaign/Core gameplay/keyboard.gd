extends Control

# UI Node
@onready var label = $VBoxContainer/MarginContainer/Label
@onready var button_sfx: AudioStreamPlayer = $Button_SFX


# signal for answer submission
signal answer_submitted(answer_text: String)

# variables
var next_char_superscript: bool = false  # Whether the next digit should be superscript
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
	
	if not typing_enabled:
		return
	
	var char_str := str(character)

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


func _on_buttonequal_pressed() -> void:
	key_pressed("=")

func _on_buttongreaterthan_pressed() -> void:
	key_pressed(">")
	
func _on_buttonlessthan_pressed() -> void:
	key_pressed("<")


func _on_buttony_pressed() -> void:
	key_pressed("y")

func _on_button_raised_pressed() -> void:
	if button_sfx:
		button_sfx.play()
	if typing_enabled:
		key_pressed("^")

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
	
	parenthesis_open = false
	typing_enabled = true

func reset_input() -> void: # call this function to manually reset keyboard input
	label.text = ""
	label.remove_theme_color_override("font_color")
	next_char_superscript = false
	
	parenthesis_open = false
	typing_enabled = true
