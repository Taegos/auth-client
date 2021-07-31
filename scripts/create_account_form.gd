extends Node

###############
# Signals
################
signal on_submit(account)

###############
# Constants
################
const EXAMPLE_USER : bool = true

###############
# Variables
################
var ControlExt = preload("res://extentions/control_ext.gd")

func _ready():
	_setup_connections()
	if EXAMPLE_USER:
		$InputBox/EmailInput.text = "test"
		$InputBox/PasswordInput.text = "12345678"
		$InputBox/ConfirmPasswordInput.text = "12345678"
	
func _setup_connections():
	$ButtonBox/CreateAccountButton.connect("button_down", self, "_submit")

func _submit():
	ControlExt.enable_children(self, false)
	$InfoLabel.text = ''
	var email: String = $InputBox/EmailInput.text
	var password: String = $InputBox/PasswordInput.text
	var confirm_password: String = $InputBox/ConfirmPasswordInput.text
	
	if password.length() < 8:
		display_error("Password has to have a length of atleast 8 characters")
	elif password != confirm_password:
		display_error("Passwords does not match")
	else:
		var account: Dictionary = {
			"email": email,
			"password": password
		}
		emit_signal("on_submit", account)
		
func display_error(error: String):
	ControlExt.enable_children(self, true)
	$InfoLabel.text = error
	$InfoLabel.add_color_override("font_color", Color.red)
