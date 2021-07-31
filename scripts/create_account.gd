extends Node

############################
# Constants
############################

const EXAMPLE_USER : bool = true

var ControlExt = preload("res://extentions/control_ext.gd")

func _ready():
	$Form.visible = false
	_setup_connections()
	if EXAMPLE_USER:
		$Form/InputBox/EmailInput.text = "test"
		$Form/InputBox/PasswordInput.text = "12345678"
		$Form/InputBox/ConfirmPasswordInput.text = "12345678"
	
func _setup_connections():
	$Form/ButtonBox/GoBackButton.connect("button_down", self, "_show_login_form")
	$Form/ButtonBox/CreateAccountButton.connect("button_down", self, "_create_account")
	$HTTP.connect("request_completed", self, "_on_request_completed")

func _on_request_completed(result: int, code: int, 
						   headers: PoolStringArray, body: PoolByteArray):
	if result != HTTPRequest.RESULT_SUCCESS || code != 201:
		ControlExt.enable_children($Form, true)
		_set_error(body.get_string_from_utf8())
	else:
		get_parent().enter_game(body.get_string_from_utf8())

func _show_login_form():
	$Form.visible = false
	$"../Login/Form".visible = true

func _create_account():	
	var email: String = $Form/InputBox/EmailInput.text
	var password: String = $Form/InputBox/PasswordInput.text
	var confirm_password: String = $Form/InputBox/ConfirmPasswordInput.text
	
	if password.length() < 8:
		_set_error("Password has to have a length of atleast 8 characters")
	elif password != confirm_password:
		_set_error("Passwords does not match")
	else:
		ControlExt.enable_children($Form, false)
		var data: Dictionary = {
			"email": email,
			"password": password
		}
		var query = JSON.print(data)
		var headers : PoolStringArray = [
			"Content-Type: application/json"
		]
		$HTTP.request(
			"https://transaticka-auth.herokuapp.com/account", 
			headers, false, 
			HTTPClient.METHOD_POST, 
			query
		)

func _set_error(text: String):
	$Form/InfoLabel.text = text
	$Form/InfoLabel.add_color_override("font_color", Color.red)
