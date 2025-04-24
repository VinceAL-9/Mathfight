extends Control

var stored_username := ""
var stored_password_hash := ""
var is_signing_up := false

func _on_signup_button_down() -> void:
	if !is_signing_up:
		# Enter sign-up mode
		is_signing_up = true
		$Login.text = "Create"
		$Signup.text = "Cancel"
		$Username.text = ""
		$Password.text = ""
		$RichTextLabel.bbcode_text = "Sign-up Mode"
		print("Switched to sign-up mode")
	else:
		# Cancel sign-up
		is_signing_up = false
		$Login.text = "Login"
		$Signup.text = "Sign Up"
		$Username.text = ""
		$Password.text = ""
		$RichTextLabel.bbcode_text = "[b]Login Mode[/b]"
		print("Cancelled sign-up")

func _on_login_button_down() -> void:
	if is_signing_up:
		# Create account
		stored_username = $Username.text.strip_edges()
		stored_password_hash = $Password.text.sha256_text()
		
		if stored_username == "" or $Password.text == "":
			$RichTextLabel.bbcode_text = "[color=red]Cannot be empty.[/color]"
			return

		print("Account created! Username: %s | Password hash: %s" % [stored_username, stored_password_hash])
		$RichTextLabel.bbcode_text = "[color=green]Account created![/color]"

		# Reset UI
		is_signing_up = false
		$Login.text = "Login"
		$Signup.text = "Sign Up"
		$Username.text = ""
		$Password.text = ""
	else:
		# Try login
		if stored_username == "":
			print("No account created yet.")
			$RichTextLabel.bbcode_text = "[color=red]No account found.[/color]"
			return

		var input_user = $Username.text.strip_edges()
		var input_pass_hash = $Password.text.sha256_text()

		if input_user == stored_username and input_pass_hash == stored_password_hash:
			print("Login successful!")
			$RichTextLabel.bbcode_text = "[color=green]Login successful!%s[/color]" % input_user
		else:
			print("Login failed.")
			$RichTextLabel.bbcode_text = "[color=red]Incorrect username or password.[/color]"

		$Username.text = ""
		$Password.text = ""








		
