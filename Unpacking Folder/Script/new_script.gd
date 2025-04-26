extends Node
@onready var label = $VBoxContainer/MarginContainer/Label

const Answer = "x²+12x-32"

var superscript_map = {
	"0": "⁰", "1": "¹", "2": "²", "3": "³", "4": "⁴",
	"5": "⁵", "6": "⁶", "7": "⁷", "8": "⁸", "9": "⁹"
}
var next_char_superscript := false
var sqrt_open := false  # Tracks if we're inside a square root expression
var parenthesis_open := false

func _ready():
	label.text = "Answer Quickly"
	await get_tree().create_timer(1.0).timeout
	label.text = ""

func key_pressed(digit):
	if next_char_superscript and str(digit).is_valid_int():
		var superscript_char = superscript_map.get(str(digit), str(digit))
		label.text += superscript_char
		next_char_superscript = false
	else:
		label.text += str(digit)

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


func _on_buttonbackspace_pressed() -> void:
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


func _on_buttonsqrt_pressed() -> void:
	if sqrt_open:
		label.text += ")"
		sqrt_open = false
	else:
		label.text += "√("
		sqrt_open = true


func _on_buttonraised_pressed() -> void:
	next_char_superscript = true


func _on_buttonparenthesis_pressed() -> void:
	if parenthesis_open:
		label.text += ")"
		parenthesis_open = false
	else:
		label.text += "("
		parenthesis_open = true


func _on_button_ok_pressed() -> void:
	if label.text == Answer:
		label.text = "Nice Job!"
		label.add_theme_color_override("font_color", Color.GREEN)
	else:
		label.text = "Skill Issue"
		label.add_theme_color_override("font_color", Color.RED)
	await get_tree().create_timer(2.0).timeout
	label.text = ""
	label.remove_theme_color_override("font_color")
