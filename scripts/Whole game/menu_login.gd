extends Control

@onready var password_field = $LoginContainer/InputContainer/Password
@onready var transition = $Transition
var stored_username := ""
var stored_password_hash := ""
var is_signing_up := false
var password_vissable := false

func _ready():
	transition.play("fade_in")
	password_field.secret = true
	
func _on_signup_button_down() -> void:
	if !is_signing_up:
		# Enter sign-up mode
		is_signing_up = true
		$LoginContainer/ButtonContainer/Login.text = "Create"
		$LoginContainer/ButtonContainer/Signup.text = "Cancel"
		$LoginContainer/InputContainer/Username.text = ""
		$LoginContainer/InputContainer/Password.text = ""
		$LoginText.bbcode_text = "Sign up"
		$WarningText.bbcode_text = " "
		print("Switched to sign-up mode")
	else:
		# Cancel sign-up
		is_signing_up = false
		$LoginContainer/ButtonContainer/Login.text = "Login"
		$LoginContainer/ButtonContainer/Signup.text = "Sign Up"
		$LoginContainer/InputContainer/Username.text = ""
		$LoginContainer/InputContainer/Password.text = ""
		$LoginText.bbcode_text = "[b]Login[/b]"
		print("Cancelled sign-up")

func _on_login_button_down() -> void:
	if is_signing_up:
		# Create account
		stored_username = $LoginContainer/InputContainer/Username.text.strip_edges()
		stored_password_hash = $LoginContainer/InputContainer/Password.text.sha256_text()
		
		if stored_username == "" or $LoginContainer/InputContainer/Password.text == "":
			$WarningText.bbcode_text = "[color=red]Cannot be empty.[/color]"
			return

		print("Account created! Username: %s | Password hash: %s" % [stored_username, stored_password_hash])
		$WarningText.bbcode_text = "[color=green]Account created![/color]"
		$LoginText.bbcode_text = "Login"

		# Reset UI
		is_signing_up = false
		$LoginContainer/ButtonContainer/Login.text = "Login"
		$LoginContainer/ButtonContainer/Signup.text = "Sign Up"
		$LoginContainer/InputContainer/Username.text = ""
		$LoginContainer/InputContainer/Password.text = ""
	else:
		# Try login
		if stored_username == "":
			print("No account created yet.")
			$WarningText.bbcode_text = "[color=red]No account found.[/color]"
			return

		var input_user = $LoginContainer/InputContainer/Username.text.strip_edges()
		var input_pass_hash = $LoginContainer/InputContainer/Password.text.sha256_text()

		if input_user == stored_username and input_pass_hash == stored_password_hash:
			print("Login successful!")
			$WarningText.bbcode_text = "[color=green]Login successful! %s[/color]" % input_user
			transition.play("fade_out")
			await get_tree().create_timer(1).timeout
			Functions.load_screen_to_scene("res://scenes/Whole game/main_menu.tscn")
		else:
			print("Login failed.")
			$WarningText.bbcode_text = "[color=red]Incorrect username or password.[/color]"

		$LoginContainer/InputContainer/Username.text = ""
		$LoginContainer/InputContainer/Password.text = ""








		
