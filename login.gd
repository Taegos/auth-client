extends Control

signal on_login(email, password)

func login_succeeded():
	_set_success("Login succeeded")
	
func login_failed(var reason: String):
	_set_error(reason)

func _ready():
	visible = true
	_setup_connections()

func _setup_connections():
	$ButtonBox/CreateAccountButton.connect("button_down", self, "_show_create_account_form")
	$ButtonBox/LoginButton.connect("button_down", self, "_login")

func _show_create_account_form():
	visible = false
	$"../CreateAccount".visible = true

func _login():
	var email: String = $InputBox/EmailInput.text
	var password: String = $InputBox/PasswordInput.text
	emit_signal("on_login", email, password)

func _set_error(text: String):
	$InfoLabel.text = text
	$InfoLabel.add_color_override("font_color", Color.red)	

func _set_success(text: String):
	$InfoLabel.text = text
	$InfoLabel.add_color_override("font_color", Color.green)	

func _set_info(text: String):
	$InfoLabel.text = text
	$InfoLabel.add_color_override("font_color", Color.white)	
