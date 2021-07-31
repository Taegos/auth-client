extends Node

var ControlExt = preload("res://extentions/control_ext.gd")

func _ready():
	$Form.visible = true
	_setup_connections()

func _setup_connections():
	$Form/ButtonBox/CreateAccountButton.connect("button_down", self, "_show_create_account_form")
	$Form/ButtonBox/LoginButton.connect("button_down", self, "_login")
	$HTTP.connect("request_completed", self, "_on_request_completed")

func _on_request_completed(result: int, code: int, 
						   headers: PoolStringArray, body: PoolByteArray):
	if result != HTTPRequest.RESULT_SUCCESS || code != 201:
		ControlExt.enable_children($Form, true)
		_set_error(body.get_string_from_utf8())
	else:
		get_parent().enter_game(body.get_string_from_utf8())
	
func _show_create_account_form():
	$Form.visible = false
	$"../CreateAccount/Form".visible = true

func _login():
	var email: String = $Form/InputBox/EmailInput.text
	var password: String = $Form/InputBox/PasswordInput.text
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
		"https://transaticka-auth.herokuapp.com/auth", 
		headers, false, 
		HTTPClient.METHOD_POST, 
		query
	)

func _set_error(text: String):
	$Form/InfoLabel.text = text
	$Form/InfoLabel.add_color_override("font_color", Color.red)
