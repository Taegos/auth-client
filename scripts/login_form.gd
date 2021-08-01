extends Node

#############
# Signals
#############
signal on_submit(account)
signal on_show_create_acc_form()

var ControlExt = preload("res://extentions/control_ext.gd")

func _ready():
	_setup_connections()

func _setup_connections():
	$ButtonBox/LoginButton.connect("button_down", self, "_submit")

func _submit():
	ControlExt.enable_children(self, false)
	$InfoLabel.text = ''
	var email: String = $InputBox/EmailInput.text
	var password: String = $InputBox/PasswordInput.text
	if email == "":
		display_error("Email cannot be left blank")
	elif password == "":
		display_error("Password cannot be left blank")
	else:
		var account: Dictionary = {
			"email": email,
			"password": password
		}
		emit_signal("on_submit", account)

func display_error(text: String):
	ControlExt.enable_children(self, true)
	$InfoLabel.text = text
	$InfoLabel.add_color_override("font_color", Color.red)
